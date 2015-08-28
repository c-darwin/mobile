// Copyright 2015 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package paint defines an event for the app being ready to paint.
//
// See the github.com/c-darwin/mobile/app package for details on the event model.
package paint // import "github.com/c-darwin/mobile/event/paint"

// Event indicates that the app is ready to paint the next frame of the GUI. A
// frame is completed by calling the App's EndPaint method.
type Event struct {
	// Generation is a monotonically increasing generation number.
	Generation uint32
}
