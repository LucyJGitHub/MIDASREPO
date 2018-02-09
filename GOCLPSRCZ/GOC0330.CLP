/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Audit Enquiry')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0330 - Audit Enquiry                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&ZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&INPT)  TYPE(*CHAR) LEN( 4)
             DCL        VAR(&FRDN)  TYPE(*DEC ) LEN( 5 0)
             DCL        VAR(&TODN)  TYPE(*DEC ) LEN( 5 0)
             DCL        VAR(&TINPT) TYPE(*CHAR) LEN( 4)
             DCL        VAR(&TUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INKC)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&INKL)  TYPE(*CHAR) LEN( 1)
 
             DCL        VAR(&FRDA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&TODA)  TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGJOB     SWS(00000000)
 
             DLTF       FILE(QTEMP/GOAUW0PD)
             MONMSG CPF0000
             DLTF       FILE(QTEMP/GOAUW0PDX)
             MONMSG CPF0000
             DLTF       FILE(QTEMP/GOAUW1PD)
             MONMSG CPF0000
             DLTF       FILE(QTEMP/GOAUW2PD)
             MONMSG CPF0000
 
             CPYF       FROMFILE(GOAUW0PD) TOFILE(QTEMP/GOAUW0PD) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(GOAUW0PD) TOFILE(QTEMP/GOAUW0PDX) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(GOAUW1PD) TOFILE(QTEMP/GOAUW1PD) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(GOAUW2PD) TOFILE(QTEMP/GOAUW2PD) +
                          CRTFILE(*YES)
 
/* Prompt */
 LOOP100:    CHGVAR     VAR(&TINPT) VALUE('    ')
             CHGVAR     VAR(&TUSER) VALUE('          ')
             CALL       PGM(GO100100) PARM(&RTCD &ERMS &ZONE &USER +
                          &INPT &FRDN &TODN &INKC &INKL)
 
/* ERROR */
/**********  IF         COND(&RTCD**= ' ') THEN(GOTO CMDLBL(ABNOR))                   */ /*BG18886*/
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))                     /*BG18886*/
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
/* END */
             IF         COND(&INKL = '1') THEN(GOTO CMDLBL(END))
 
/* NO USER OR INPUT SPECIFIED ============================================  */
 
             IF         COND(&USER = ' ' *AND &INPT = ' ') THEN(DO)
 
             OVRDBF     FILE(GPAUCHPD) SHARE(*YES) OPNSCOPE(*JOB)
             CHGVAR     VAR(&FRDA) VALUE(&FRDN)
             CHGVAR     VAR(&TODA) VALUE(&TODN)
             OPNQRYF    FILE((GPAUCHPD)) QRYSLT('AHZONE *EQ "' *CAT +
                          &ZONE *CAT '" *AND AHRDNB *GE  ' *CAT +
                          &FRDA *CAT '  *AND AHRDNB *LE  ' *CAT &TODA)
             CPYFRMQRYF FROMOPNID(GPAUCHPD) TOFILE(QTEMP/GOAUW0PD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             CLOF       OPNID(GPAUCHPD)
             DLTOVR     FILE(GPAUCHPD)
 
             OVRDBF     FILE(GOAUW0PD) TOFILE(QTEMP/GOAUW0PD) +
                          SHARE(*YES) OPNSCOPE(*JOB)
             OPNQRYF    FILE((GOAUW0PD)) KEYFLD((AHINPT) (AHUSER)) +
                          GRPFLD(AHINPT AHUSER) MAPFLD((AHCNT +
                          '%COUNT'))
             CPYFRMQRYF FROMOPNID(GOAUW0PD) TOFILE(QTEMP/GOAUW0PDX) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
             CLOF       OPNID(GOAUW0PD)
             DLTOVR     FILE(GOAUW0PD)
 
/* Summary */
 
LOOP102:     OVRDBF     FILE(GOAUW0PD) TOFILE(QTEMP/GOAUW0PDX)
             CALL       PGM(GO100102) PARM(&RTCD &ERMS &TINPT &TUSER +
                          &ZONE &USER &INPT &FRDN &TODN &INKC &INKL)
             DLTOVR     FILE(GOAUW0PD)
 
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
/* ABANDON */
             IF         COND(&INKL = '1') THEN(GOTO CMDLBL(LOOP100))
 
             ENDDO
 
 
             OVRDBF     FILE(GPAUCHPD) SHARE(*YES) OPNSCOPE(*JOB)
 
             CHGVAR     VAR(&FRDA) VALUE(&FRDN)
             CHGVAR     VAR(&TODA) VALUE(&TODN)
 
/* INPUT NOT SELECTED ========================================================  */
 
/**********  IF         COND(&INPT**= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&INPT *NE ' ') THEN(DO)                                     /*BG18886*/
 
/**********  IF         COND(&USER**= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&USER *NE ' ') THEN(DO)                                     /*BG18886*/
             OPNQRYF    FILE((GPAUCHPD)) QRYSLT('AHZONE *EQ "' *CAT +
                          &ZONE *CAT '" *AND AHUSER *EQ "' *CAT +
                          &USER *CAT '" *AND AHINPT *EQ "' *CAT +
                          &INPT *CAT '" *AND AHRDNB *GE  ' *CAT +
                          &FRDA *CAT '  *AND AHRDNB *LE  ' *CAT +
                          &TODA)
             ENDDO
             IF         COND(&USER = ' ') THEN(DO)
             OPNQRYF    FILE((GPAUCHPD)) QRYSLT('AHZONE *EQ "' *CAT +
                          &ZONE *CAT '" *AND AHINPT *EQ "' *CAT +
                          &INPT *CAT '" *AND AHRDNB *GE  ' *CAT +
                          &FRDA *CAT '  *AND AHRDNB *LE  ' *CAT +
                          &TODA)
             ENDDO
 
             CPYFRMQRYF FROMOPNID(GPAUCHPD) TOFILE(QTEMP/GOAUW1PD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
             CLOF       OPNID(GPAUCHPD)
             DLTOVR     FILE(GPAUCHPD)
 
/* Enquiry - Input */
 
             OVRDBF     FILE(GOAUW1PD) TOFILE(QTEMP/GOAUW1PD)
             CALL       PGM(GO100104) PARM(&RTCD &ERMS &ZONE &USER +
                          &INPT &FRDN &TODN &INKC &INKL)
             DLTOVR     FILE(GOAUW1PD)
 
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
 
             IF         COND(&TINPT = ' ' *AND &TUSER = ' ') THEN(GOTO +
                          CMDLBL(LOOP100))
 
             GOTO CMDLBL(LOOP102)
 
             ENDDO
 
/* INPUT SPECIFIED ===========================================================  */
 
             IF         COND(&INPT = ' ') THEN(DO)
 
             OPNQRYF    FILE((GPAUCHPD)) QRYSLT('AHZONE *EQ "' *CAT +
                          &ZONE *CAT '" *AND AHUSER *EQ "' *CAT +
                          &USER *CAT '" *AND AHRDNB *GE  ' *CAT +
                          &FRDA *CAT '  *AND AHRDNB *LE  ' *CAT +
                          &TODA)
 
             CPYFRMQRYF FROMOPNID(GPAUCHPD) TOFILE(QTEMP/GOAUW2PD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
             CLOF       OPNID(GPAUCHPD)
             DLTOVR     FILE(GPAUCHPD)
 
/* Enquiry - User */
 
             OVRDBF     FILE(GOAUW2PD) TOFILE(QTEMP/GOAUW2PD)
             CALL       PGM(GO100106) PARM(&RTCD &ERMS &ZONE &USER +
                          &INPT &FRDN &TODN &INKC &INKL)
             DLTOVR     FILE(GOAUW2PD)
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
 
             IF         COND(&TINPT = ' ' *AND &TUSER = ' ') THEN(GOTO +
                          CMDLBL(LOOP100))
 
             GOTO CMDLBL(LOOP102)
 
             ENDDO
 
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0330 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
