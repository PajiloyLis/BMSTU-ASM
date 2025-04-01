#ifndef MAIN_WINDOW_HPP
#define MAIN_WINDOW_HPP

#include <QFileDialog>
#include <QCoreApplication>
#include <QLabel>
#include <QObject>
#include <QPushButton>
#include <iostream>
#include <string>
#include <map>
#include <QWidget>
#include <SFML/Graphics.hpp>
#include "kek_ui.h"

class MainWindow : public QMainWindow {
public:
    MainWindow();

    ~MainWindow() override = default;

private slots:
    void BinarizeButtonClicked();

    void LoadFileButtonClicked();

private:
    void SetBindings();
};

#endif