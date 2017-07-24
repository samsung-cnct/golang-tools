/*
Copyright 2016 The Barrel Authors. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmd

import (
	"fmt"
	"os"

	"github.com/samsung-cnct/golang-tools/example-project/apkg"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var Verbose bool
var cfgFile string
var ScriptPathArg string

func ScriptPath() string {
	return os.ExpandEnv(ScriptPathArg)
}

// RootCmd represents the base command when called without any subcommands
var RootCmd = &cobra.Command{
	Use:   "example-app",
	Short: "A Continuous Chaotic Error Injector and Monitor",
	Long: `This program is a chaos monkey based continuous error
injector and monitor.

It attempts to be easily extensible.`,

	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		apkg.Verbose = Verbose
	},

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("You must specify more options")
		cmd.Usage()
	},
}

// Execute adds all child commands to the root command sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := RootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports Persistent Flags, which, if defined here,
	// will be global for your application.
	RootCmd.PersistentFlags().StringVarP(&cfgFile, "config", "c", "", "example-app configuration file (default is $HOME/.example-app.yaml)")
	RootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "More verbose output")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" { // enable ability to specify config file via flag
		viper.SetConfigFile(cfgFile)
	}

	viper.SetConfigName(".example-app") // name of config file (without extension)
	viper.AddConfigPath("$HOME")        // adding home directory as first search path
	viper.AutomaticEnv()                // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}
}
