pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  //property real cpu_percent
  property string mem_used
  property list<real> cpu_cores_percent

  //Process {
  //  id: process_cpu_percent
  //  running: true
  //  command: ["sh", "-c", "top -bn1 | awk 'NR==3'"]
  //  stdout: SplitParser {
  //    onRead: data => {
  //      const idle = data.split(',')[3].trim().split(' ')[0];
  //      cpu_percent = (100 - idle).toFixed(1);
  //    }
  //  }
  //}

  Process {
    id: process_cpu_cores_percent
    running: true
    command: ["sh", "-c", "mpstat -P ALL 1 1 | awk '/Average/ && $2 ~ /^[0-9]+$/ {print 100 - $12}' | paste -sd ','"]
    stdout: SplitParser {
      onRead: data => cpu_cores_percent = data.trim().split(",")
    }
  }

  Process {
    id: process_mem_used
    running: true
    command: ["sh", "-c", "free -h | awk 'NR==2{print $3}'"]
    stdout: SplitParser {
      onRead: data => mem_used = data
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: () => {
      //process_cpu_percent.running = true
      process_cpu_cores_percent.running = true
      process_mem_used.running = true
    }
  }
}

