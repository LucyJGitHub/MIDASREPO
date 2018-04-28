/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Loan number ranges maintenance control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC1330 - Loan Number Ranges Maintenance Control            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/*                      CLE105  *CREATE    Date 24MAR00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CCB009 - Journal files throughout close of business         */
/*       CLE105 - Separation of the enhanced LE input screens from   */
/*                the background processing.                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,SDC1330INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature                        */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                        */ /*CCB009 CCB020*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.                                        */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SDC1330MPS                                          */
 
/**Retrieve*the*phase*of*day**/                                                           /*CCB020*/
 
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                             */ /*CCB020*/
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),                */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/* If the system is not in input cycle then journal the files */
/* used by SD1330M                                            */
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
/**********     STRJRNPF   FILE(SDLENOPD SDFCTLPD) +
                             JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
/* Call loan number ranges maintenance */
 
                CALL       PGM(SD1330M) PARM(' ')
 
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
 
/* Call loan number ranges maintenance */
 
                CALL       PGM(SD1330M) PARM(' ')
 
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
 
             /* There is no switch off processing required */
 
             ENDDO
 
/*/COPY WNCPYSRC,SDC1330MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SDC1330ERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program SDC1330 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SDC1330END                                          */
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),                */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**If*the*system*is*not*in*input*cycle*then*end*journalling**/                            /*CCB020*/
/**on*the*files*used*by*SD1330M******************************/                            /*CCB020*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
/**********     ENDJRNPF   FILE(SDLENOPD SDFCTLPD)                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
 
             ENDPGM
