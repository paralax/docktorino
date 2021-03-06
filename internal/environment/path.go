// Copyright © 2018 NAME HERE adel.zalok.89@gmail.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.e License.

package environment

import (
	"os"
	"path/filepath"
)

// ConfigHome describes the location of a CLI configuration.
// This helper builds paths relative to a Docktorino Home directory.
type ConfigHome string

// String returns Home as a string.
// Implements fmt.Stringer.
func (h ConfigHome) String() string {
	return os.ExpandEnv(string(h))
}

// Path returns Home with elements appended.
func (h ConfigHome) Path(elem ...string) string {
	p := []string{h.String()}
	p = append(p, elem...)
	return filepath.Join(p...)
}

// TLSCaCert returns the path to fetch the CA certificate.
func (h ConfigHome) TLSCaCert() string {
	return h.Path("ca.pem")
}

// TLSCert returns the path to fetch the client certificate.
func (h ConfigHome) TLSCert() string {
	return h.Path("cert.pem")
}

// TLSKey returns the path to fetch the client public key.
func (h ConfigHome) TLSKey() string {
	return h.Path("key.pem")
}
