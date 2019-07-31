/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD-Delete Recs Flagged For Deletion')           */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                  */
/*       SDC0605A - DELETE RECORDS FLAGGED FOR DELETION             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 055652             Date 25Jan96              */
/*                      E10967             Date 02/06/87             */
/*                      E10046            DATE  05/12/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       055652 - CHANGE PROGRAM TO CREATE THE TEMPORARY            */
/*                INTERIM FILE.                                     */
/*       E10967 - ERROR FIX TO CATER FOR EMPTY FILES PROPERLY       */
/*       E10046 - PROGRAM DOES NOT MONITOR FOR MESSAGE CAUSED       */
/*                BY EMPTY FILES                                    */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&FILE &TEMP)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                            */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&TEMP) TYPE(*CHAR) LEN(7)                 /*055652*/
             DCL        VAR(&TEMP) TYPE(*CHAR) LEN(1)                 /*055652*/
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)                /*055652*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)                 /*055652*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*055652*/
                                                                      /*055652*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))       /*055652*/
                                                                      /*055652*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*055652*/
             CHGVAR     VAR(&LIB) VALUE(%SUBSTRING(&SDSTAT 6 2) *CAT +
                          'DPLIB')                                    /*055652*/
             CHGVAR     VAR(&NAME) VALUE('SDC0605A' *CAT &TEMP)       /*055652*/
/*                                                                            */
/**********  CLRPFM     FILE(&TEMP)                       /*E10967 */ /*055652*/
             DLTF       FILE(&LIB/&NAME)                              /*055652*/
             MONMSG     MSGID(CPF2105)                                /*055652*/
/*                                                                *  * E10967 */
/**********  CPYF    FROMFILE(&FILE) TOFILE(&TEMP) MBROPT(*REPLACE)-  /*055652*/
/**********               INCCHAR(*RCD 1 *NE *) FMTOPT(*NOCHK)        /*055652*/
             CPYF       FROMFILE(&FILE) TOFILE(&LIB/&NAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCCHAR(*RCD 1 *NE *) FMTOPT(*NOCHK)        /*055652*/
                                                                    /* E10046 */
/*           MONMSG     MSGID(CPF2817)                            *  * E10967 */
/**********  MONMSG     MSGID(CPF2817) EXEC(DO) **/                   /*055652*/
/**********    GOTO       CMDLBL(ENDPGM)        **/                   /*055652*/
/**********  ENDDO                              **/                   /*055652*/
                                                                    /* E10046 */
/**********  CPYF     FROMFILE(&TEMP) TOFILE(&FILE) MBROPT(*REPLACE)- /*055652*/
/**********               FMTOPT(*NOCHK)                              /*055652*/
             CPYF       FROMFILE(&LIB/&NAME) TOFILE(&FILE) +
                          MBROPT(*REPLACE)                            /*055652*/
             MONMSG     MSGID(CPF2817)
                                                                    /* E10046 */
             DLTF       FILE(&LIB/&NAME)                              /*055652*/
             MONMSG     MSGID(CPF2105)                                /*055652*/
                                                                      /*055652*/
             GOTO       CMDLBL(ENDPGM)                                /*055652*/
                                                                      /*055652*/
 ABNOR:                                                               /*055652*/
             DMPCLPGM
             CHGJOB     SWS(XXXXXX11)                                 /*055652*/
             SNDPGMMSG  MSG('File reorganisation ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)                              /*055652*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*055652*/
/*                                                                            */
 ENDPGM:                                                              /*055652*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 /*ENDPGM:***ENDPGM                                        /*E10967*/ /*055652*/
             ENDPGM                                                   /*055652*/
