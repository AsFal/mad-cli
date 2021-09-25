package cmd

import (
	"fmt"
	"mad-cli/pkg/generator"
	"os"

	"github.com/spf13/cobra"
)

// generateCmd represents the generate command
var generateCmd = &cobra.Command{
	Use:   "generate",
	Short: "Generates application modules",
	Long:  "Generates application modules following mad React Native folder conventions",
}

type screenCmdFlags struct {
	name string
	app  string
}

func parseScreenCmdFlags(cmd *cobra.Command) (screenCmdFlags, error) {
	var err error
	flags := screenCmdFlags{}

	flags.name, err = cmd.Flags().GetString("name")
	if err != nil {
		return flags, err
	}
	flags.app, err = cmd.Flags().GetString("app")
	if err != nil {
		return flags, err
	}
	return flags, nil
}

var screenCmd = &cobra.Command{
	Use:   "screen",
	Short: "Generates a new Screen",
	Long:  "Generates a new Screen",
	Run: func(cmd *cobra.Command, args []string) {
		flags, err := parseScreenCmdFlags(cmd)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		generator.GenerateScreen(flags.app, flags.name)
	},
}

func init() {
	rootCmd.AddCommand(generateCmd)

	generateCmd.AddCommand(screenCmd)
	screenCmd.Flags().String("name", "n", "The screen name")
	screenCmd.Flags().String("app", "a", "The application name under which the screen will be nested")
}
