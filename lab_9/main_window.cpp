#include "main_window.h"

static sf::Image binarize(const std::string &path);

MainWindow::MainWindow() : QMainWindow() {
    std::setlocale(LC_ALL, "");
    Ui::MainWindow ui;
    ui.setupUi(this);
//    auto *edit = this->findChild<QLineEdit *>("NumberEdit");
//    edit->setPlaceholderText("Введите коэффициент от -1 до 1");
    this->SetBindings();
}

void MainWindow::SetBindings() {
    QObject::connect(this->findChild<QPushButton *>("OpenFileButton"), &QPushButton::clicked, this,
                     &MainWindow::LoadFileButtonClicked);
    QObject::connect(this->findChild<QPushButton *>("BinarizeButton"), &QPushButton::clicked, this,
                     &MainWindow::BinarizeButtonClicked);
}


void MainWindow::BinarizeButtonClicked() {
    auto *file_name_label = this->findChild<QLabel *>("FileNameLabel");
    std::string file_name = file_name_label->text().toStdString();
    sf::Image new_image = binarize(file_name);
    auto save_file_name = QFileDialog::getSaveFileName().toStdString();
    new_image.saveToFile(save_file_name);
}

void MainWindow::LoadFileButtonClicked() {
    auto *file_name = this->findChild<QLabel *>("FileNameLabel");
    auto file_name_str = QFileDialog::getOpenFileName().toStdString();
    file_name->setText(QString(file_name_str.c_str()));
}

static sf::Image binarize(const std::string &path) {
    sf::Image image;
    image.loadFromFile(path);
    std::cout << image.getSize().x<<'\n';
    for (unsigned int i = 0; i < image.getSize().y; ++i) {
        for (unsigned int j = 0; j < image.getSize().x; j++) {
            std::uint32_t color = image.getPixel(j, i).toInteger();
            float colors[4] = {float((color & (255 << 24)) >> 24), float((color & (255 << 16)) >> 16), float((color & (255 << 8)) >> 8), float(color & 255)};
//            std::cout << "Old color:\nred   - " << colors[0] << "\ngreen - " << colors[1] << "\nblue  - " << colors[2]
//                      << "\nalpha - " << colors[3] << '\n';
            std::uint32_t maxes[4] = {255, 255, 255, 255};
            float new_colors[4];
            float buf_1[4], buf_2[4];
            float coefs[4] = {0.299, 0.587, 0.114, 1};
            asm(
                    "movaps %3, %%xmm0\n" // in xmm0 rgba
                    "movaps %4, %%xmm1\n"
                    "mulps %%xmm1, %%xmm0\n" // multiplied colors in xmm0
                    "movaps %%xmm0, %%xmm2\n" // rgba in xmm2
                    "psrldq $4, %%xmm2\n" // gba# in xmm2
                    "movaps %%xmm2, %1\n"
                    "addss %%xmm2, %%xmm0\n" // abg(r+g) in xmm0
                    "psrldq $4, %%xmm2\n" // ##ab in xmm2
                    "movaps %%xmm2, %2\n"
                    "addss %%xmm2, %%xmm0\n" // abg(r+b+g) in xmm0
                    "movaps %5, %%xmm3\n"
                    "subss %%xmm0, %%xmm3\n" //inversed color
                    "movaps %%xmm3, %0\n"
                    : "=m" (new_colors), "=m"(buf_1), "=m"(buf_2)
                    : "m" (colors), "m" (coefs), "m" (maxes)
                    :
                    );
//            std::cout << "Buf_1 color:\nred   - " << buf_1[0] << "\ngreen - " << buf_1[1] << "\nblue  - "
//                      << buf_1[2] << "\nalpha - " << buf_1[3] << '\n';
//            std::cout << "Buf_2 color:\nred   - " << buf_2[0] << "\ngreen - " << buf_2[1] << "\nblue  - "
//                      << buf_2[2] << "\nalpha - " << buf_2[3] << '\n';
//            std::cout << "New color:\nred   - " << new_colors[0] << "\ngreen - " << new_colors[1] << "\nblue  - "
//                      << new_colors[2] << "\nalpha - " << new_colors[3] << '\n';
//            float new_color = new_colors[1]+new_colors[2]+new_colors[3];
            image.setPixel(j, i, sf::Color(new_colors[0], new_colors[0], new_colors[0], (color & 255)));
        }
    }
    return image;
}