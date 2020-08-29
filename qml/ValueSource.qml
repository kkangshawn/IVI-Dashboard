/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
//! [0]
Item {
    id: valueSource
    property real kph: accelPedal ? gearMaxLimit : breakPedal ? 0 : gearMinLimit
    property real rpm: gear == 0 ? 0 : 1
    property int turnSignal: turnSignalLever ? direction : -1
    property real fuel: 0.85
    property real temperature: 0.6

    property bool turnSignalLever: false
    property int direction: -1
    property bool accelPedal: false
    property bool breakPedal: false
    property int gear: 0
    property real gearMaxLimit: 40
    property real gearMinLimit: 0
    property int speedDuration: 1000
    property int rpmDuration: 1000

//! [0]

    Component.onCompleted: forceActiveFocus()
    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Shift:
            switch (direction) {
            case Qt.RightArrow:
                direction = -1;
                turnSignalLever = false;
                break;
            case -1:
                direction = Qt.LeftArrow;
                turnSignalLever = true;
                break;
            default:
                break;
            }
            break;
        case Qt.Key_Tab:
            switch (direction) {
            case Qt.LeftArrow:
                direction = -1;
                turnSignalLever = false;
                break;
            case -1:
                direction = Qt.RightArrow;
                turnSignalLever = true;
                break;
            default:
                break;
            }
            break;
        case Qt.Key_Alt:
            accelPedal = true;
            if (gear == 0) {
                gear = 1
            }
            rpm = tachometer.maximumValue - 1
            break;
        case Qt.Key_Control:
            breakPedal = true;
            break;
        default:
            console.log("Unassigned Key pressed");
            break;
        }
    }

    Keys.onReleased: {
        switch (event.key) {
        case Qt.Key_Alt:
            accelPedal = false;
            rpm = 1;
            break;
        case Qt.Key_Control:
            breakPedal = false;
            break;
        default:
            break;
        }
    }

    onAccelPedalChanged: {
        console.log(accelPedal ? "Accel pedal pressed" : "Accel pedal released")
    }
    onBreakPedalChanged: {
        console.log(breakPedal ? "Break pedal pressed" : "Break pedal released")
    }

    onGearChanged: {
        switch (gear) {
        case 0:
            gearMaxLimit = 40;
            gearMinLimit = 0;
            speedDuration = 1000;
            rpm = 0;
            break;
        case 1:
            gearMaxLimit = 40;
            gearMinLimit = 15;
            speedDuration = 1200;
            rpmDuration = 1000;
            rpm = 1
            break;
        case 2:
            gearMaxLimit = 60;
            gearMinLimit = 31;
            speedDuration = 1500;
            rpmDuration = 1000;
            rpm = 1
            break;
        case 3:
            gearMaxLimit = 90
            gearMinLimit = 51
            speedDuration = 1800;
            rpmDuration = 1000;
            rpm = 3
            break;
        case 4:
            gearMaxLimit = 130
            gearMinLimit = 80
            speedDuration = 3000;
            rpmDuration = 2000;
            rpm = 4
            break;
        case 5:
            gearMaxLimit = 210
            gearMinLimit = 120
            speedDuration = 4000;
            rpmDuration = 2000;
            rpm = 5
            break;
        default:
            break;
        }
    }

    onKphChanged: {
        if (kph == 0) {
            gear = 0;
        }
        else if (kph > 0 && kph < 30) {
            gear = 1;
        }
        else if (kph >= 30 && kph < 50) {
            gear = 2;
        }
        else if (kph >= 50 && kph < 80) {
            gear = 3;
        }
        else if (kph >= 80 && kph < 120) {
            gear = 4;
        }
        else if (kph >= 120 && kph < 160) {
            gear = 5;
        }
        else {
            gear = 5;
        }
    }

    onRpmChanged: {
        if (rpm > 0 && rpm % 1 == 0) {
            rpm = accelPedal ? tachometer.maximumValue - 1 : 1
        }
    }

    Behavior on kph {
        NumberAnimation {
            duration: speedDuration
        }
    }

    Behavior on rpm {
        NumberAnimation {
            duration: rpmDuration
        }
    }
}
