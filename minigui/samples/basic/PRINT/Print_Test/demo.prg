/*
  MINIGUI - Harbour Win32 GUI library Demo/Sample
 
  Copyright 2002-06 Roberto Lopez <harbourminigui@gmail.com>
  http://harbourminigui.googlepages.com/

  Desarrollado con Harbour Compiler y
  MINIGUI - Harbour Win32 GUI library (HMG).

  Copyright 2007 Jose Miguel <josemisu@yahoo.com.ar>

  modified: 11/05/2016 Pete D.
*/

#include "minigui.ch"
#include "winprint.ch"
#xtranslate _BCOLOR => HexToRGBArray( 0xffffffff )
#xtranslate _FCOLOR => HexToRGBArray( 0x210890ff )
PROCEDURE Main()
LOCAL aIMP90

   INIT PRINTSYS
   GET PRINTERS TO aIMP90
   RELEASE PRINTSYS

   DEFINE WINDOW W_Imp1 ;
      AT 10,10 ;
      WIDTH 800 HEIGHT 600 ;
      TITLE 'Printer inspection' ;
      MAIN ;
      NOMAXIMIZE ;
      NOSIZE BACKCOLOR _BCOLOR

      @15,10 LABEL L_ImpDef1 VALUE "GET DEFAULT PRINTER TO" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @10,200 TEXTBOX T_ImpDef1 WIDTH 300

      @45,10 LABEL L_Impresora VALUE "GET PRINTERS TO" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @40,200 COMBOBOX C_Impresora WIDTH 300 ;
            ITEMS aIMP90 VALUE 1 ON CHANGE Update1()

      @75,10 LABEL L_PRINTER VALUE "GET SELECTED PRINTER TO" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @70,200 TEXTBOX T_PRINTER WIDTH 300

      @105,10 LABEL L_BACKCOLOR VALUE "GET BACKCOLOR TO" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @100,200 TEXTBOX T_BACKCOLOR WIDTH 300 // NUMERIC RIGHTALIGN

      @135,10 LABEL L_TEXTCOLOR VALUE "GET TEXTCOLOR TO" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @130,200 TEXTBOX T_TEXTCOLOR WIDTH 300 // NUMERIC RIGHTALIGN

      @10,540 FRAME Frame_1 CAPTION "SET UNITS" WIDTH 220 HEIGHT 205 BACKCOLOR _FCOLOR BOLD //TRANSPARENT 
		// LABEL L_UNITS VALUE "SET UNITS" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR
      @30,600 RADIOGROUP R_UNITS ;
              OPTIONS { 'ROWCOL' , 'MM' , 'INCHES' , 'PIXELS' } ;
              VALUE 2 ;
              WIDTH 75 SPACING 25 ;
				  TRANSPARENT BACKCOLOR _BCOLOR FONTCOLOR _FCOLOR ;				  
              ON CHANGE Update2()

      @145,550 LABEL L_HBPRNMAXROW VALUE "HBPRNMAXROW" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @140,650 TEXTBOX T_HBPRNMAXROW WIDTH 100 NUMERIC RIGHTALIGN

      @175,550 LABEL L_HBPRNMAXCOL VALUE "HBPRNMAXCOL" AUTOSIZE TRANSPARENT FONTCOLOR _FCOLOR BOLD
      @170,650 TEXTBOX T_HBPRNMAXCOL WIDTH 100 NUMERIC RIGHTALIGN
		
		@ 250, 600 BUTTON But_Exit Caption "Exit" ACTION ThisWindow.Release

      @160,10 GRID GR_Bins ;
      HEIGHT 100 ;
      WIDTH 250 ;
      HEADERS {'GET BINS TO','Number'} ;
      WIDTHS {150,80 } ;
      ITEMS {} ;
      VALUE 1

      @160,270 GRID GR_PORTS ;
      HEIGHT 100 ;
      WIDTH 230 ;
      HEADERS {'GET PORTS TO'} ;
      WIDTHS {200} ;
      ITEMS {} ;
      VALUE 1

      @270,10 GRID GR_Papers ;
      HEIGHT 280 ;
      WIDTH 490 ;
      HEADERS {'GET PAPERS TO','Number', 'width (mm)', 'high (mm)'} ;
      WIDTHS {200,80,80,80 } ;
      ITEMS {} ;
      VALUE 1 ON CHANGE Update2()

      Update1()

      ON KEY ESCAPE ACTION ThisWindow.Release

      END WINDOW

      CENTER WINDOW W_Imp1
      ACTIVATE WINDOW W_Imp1

Return


STATIC FUNCTION Update1()
LOCAL ImpresoraDefecto, cPRINTER, aIMP91, aIMP92, aPORTS, nBACKCOLOR, nTEXTCOLOR
LOCAL aIMP91B, aIMP92B, N

   INIT PRINTSYS
   GET DEFAULT PRINTER TO ImpresoraDefecto
   SELECT PRINTER W_Imp1.C_Impresora.DisplayValue
   GET SELECTED PRINTER TO cPRINTER
   GET BINS TO aIMP91
   GET PAPERS TO aIMP92
   GET PORTS TO aPORTS
   GET BACKCOLOR TO nBACKCOLOR
   GET TEXTCOLOR TO nTEXTCOLOR
   RELEASE PRINTSYS

	
W_Imp1.T_ImpDef1.Value:=ImpresoraDefecto
W_Imp1.T_PRINTER.Value:=cPRINTER
// W_Imp1.T_BACKCOLOR.Value:=nBACKCOLOR
// W_Imp1.T_TEXTCOLOR.Value:=nTEXTCOLOR
W_Imp1.T_BACKCOLOR.Value:= hb_ValToExp( HexToRGBArray( nBACKCOLOR ) )
W_Imp1.T_TEXTCOLOR.Value:= hb_ValToExp( HexToRGBArray( nTEXTCOLOR ) )


aIMP91B:={}
FOR N=1 TO LEN(aIMP91)
   DO CASE
   CASE LEN(aIMP91[N])=1
      AADD(aIMP91B,{aIMP91[N],""})
   CASE LEN(aIMP91[N])=2
      AADD(aIMP91B,aIMP91[N])
   ENDCASE
NEXT
W_Imp1.GR_Bins.DeleteAllItems
IF LEN(aIMP91B)>0
   FOR N=1 TO LEN(aIMP91B)
      W_Imp1.GR_Bins.AddItem(aIMP91B[N])
   NEXT
ENDIF
W_Imp1.GR_Bins.Refresh


W_Imp1.GR_PORTS.DeleteAllItems
IF LEN(aPORTS)>0
   FOR N=1 TO LEN(aPORTS)
      IF N==W_Imp1.C_Impresora.Value
         W_Imp1.GR_PORTS.AddItem({aPORTS[N]})
         EXIT
      ENDIF
   NEXT
ENDIF
W_Imp1.GR_PORTS.Refresh



aIMP92B:={}

FOR N=1 TO LEN(aIMP92)
   IF LEN(aIMP92[N])=4
		aIMP92[N,3] := hb_NtoS( Val(aIMP92[N,3])/10 )
		aIMP92[N,4] := hb_NtoS( Val(aIMP92[N,4])/10 ) // Left(aIMP92[N,4],3)+","+Right(aIMP92[N,4],1)
      AADD(aIMP92B,aIMP92[N])
   ENDIF
NEXT
W_Imp1.GR_Papers.DeleteAllItems
IF LEN(aIMP92B)>0
   FOR N=1 TO LEN(aIMP92B)
      W_Imp1.GR_Papers.AddItem(aIMP92B[N])
   NEXT
   W_Imp1.GR_Papers.Refresh
ENDIF
IF W_Imp1.GR_Papers.ItemCount>1
   W_Imp1.GR_Papers.Value:=1
ENDIF

Return Nil


STATIC FUNCTION Update2()

   INIT PRINTSYS
   SELECT PRINTER W_Imp1.C_Impresora.DisplayValue
   SET PAGE PAPERSIZE VAL(W_Imp1.GR_Papers.Cell(W_Imp1.GR_Papers.Value,2))
   DO CASE
   CASE W_Imp1.R_UNITS.Value=1
      SET UNITS ROWCOL
   CASE W_Imp1.R_UNITS.Value=2
      SET UNITS MM
   CASE W_Imp1.R_UNITS.Value=3
      SET UNITS INCHES
   CASE W_Imp1.R_UNITS.Value=4
      SET UNITS PIXELS
   ENDCASE
   W_Imp1.T_HBPRNMAXROW.Value:=HBPRNMAXROW
   W_Imp1.T_HBPRNMAXCOL.Value:=HBPRNMAXCOL
   RELEASE PRINTSYS

Return Nil

STATIC FUNCTION HexToRGBArray( nHex ) // func added by Pete D.
	RETURN { hb_bitAnd( nHex, 0xFF ), ;
	         hb_bitAnd( hb_bitShift( nHex,  -8 ), 0xFF ),;
				hb_bitAnd( hb_bitShift( nHex, -16 ), 0xFF ) }