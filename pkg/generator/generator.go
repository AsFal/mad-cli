package generator

import (
	"embed"
	"fmt"
	"os"
	"path"
	"text/template"
)

//go:embed static/*
var fs embed.FS

const componentFile = "Component.tsx"
const indexFile = "index.ts"

type screenAttributes struct {
	ScreenName string
}

type newFileData struct {
	templatePath string
	destPath     string
}

func GenerateScreen(appName string, screenName string) {

	screenFiles := path.Join("static", "screen")
	dest := path.Join(
		"src", "apps", appName, "screens", fmt.Sprintf("%sScreen", screenName), fmt.Sprintf("%sScreen.tsx", screenName),
	)
	err := os.MkdirAll(dest, os.ModePerm)
	if err != nil {
		fmt.Println(err)
	}

	newFiles := []newFileData{
		{
			templatePath: path.Join(screenFiles, componentFile),
			destPath:     path.Join(dest, fmt.Sprintf("%sScreen.tsx", screenName)),
		},
		{
			templatePath: path.Join(screenFiles, indexFile),
			destPath:     path.Join(dest, indexFile),
		},
	}

	for _, newFile := range newFiles {
		tm := template.Must(template.ParseFS(fs, newFile.templatePath))
		f, err := os.Create(newFile.destPath)
		if err != nil {
			fmt.Println(err)
		}
		err = tm.Execute(f, screenAttributes{
			ScreenName: screenName,
		})
		if err != nil {
			fmt.Println(err)
		}
	}
}
