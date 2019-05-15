/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FOREIGN CURRENCY POSITION ENQUIRY')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0304 - FOREIGN CURRENCY POSITION ENQUIRY                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. 180788             Date 30Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU012             Date 16Feb98              */
/*                      DT0174             Date 17May91              */
/*                      S01194             Date 01Aug89              */
/*                      E14948                  DATE  04/11/88      */
/*                                                                  */
/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       180788 - Allow more than two users to access the Foreign    */
/*                Currency Positions Enquiry screen at the same time.*/
/*       CEU012 - EMU Position/Risk Enquiry                          */
/*       DT0174  -  Prevent status messages showing while query     */
/*                  runs                                            */
/*       S01194  -  NEW STANDING DATA                               */
/*       E14948  -  SWITCHES U7 & U8 WERE NOT BEING SET OFF BEFORE  */
/*                  RPG PROGRAMS WERE CALLED                        */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU012*/
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(1)               /*CEU012*/
             DCL        VAR(&EUCCY) TYPE(*CHAR) LEN(3)                /*CEU012*/
/**/                                                                  /*CEU012*/
/* Check if CEU012 is installed */                                    /*CEU012*/
/**/                                                                  /*CEU012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU012*/
             CHGVAR     VAR(&SARD) VALUE('CEU012')                    /*CEU012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CEU012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU012) VALUE('Y'))                    /*CEU012*/
/**/                                                                  /*CEU012*/
/* Error */                                                           /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU012*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU012*/
                CHGJOB (XXXXXX11)                                     /*CEU012*/
                GOTO       CMDLBL(EXIT)                               /*CEU012*/
             ENDDO                                                    /*CEU012*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
                                                        /* E14948 */
             CHGJOB     SWS(XXXXXX00)
                                                        /* E14948 */
/*                                                      Start DT0174 */
/** Disable status messages:                                         */
             CHGJOB     STSMSG(*NONE)
 
             IF         COND(&CEU012 *EQ 'Y') THEN(DO)                /*CEU012*/
/***********    OVRDBF     FILE(GLOLEMPD) SHARE(*NO)   ***/    /*CUE012 180788*/
                OVRDBF     FILE(GLOLPEL1) TOFILE(OLPOS4) +
                             SHARE(*YES)                              /*180788*/
                OVRDBF     FILE(GLOLPEL2) TOFILE(OLPOS5) +
                             SHARE(*YES)                              /*180788*/
/***********    CLOF       (GLOLEMPD)   ***/                   /*CEU012 180788*/
/***********    MONMSG     MSGID(CPF0000)   ***/               /*CEU012 180788*/
/***********    OPNQRYF    FILE((OLPOSOA *FIRST OLPOSOAF) (SDCURRPD +
                             *FIRST *ONLY)) FORMAT(GLOLEMPD) +
                             KEYFLD((*MAPFLD/SSNB *ASCEND) +
                             (OLPOSOA/CCY)) JFLD((OLPOSOA/CCY +
                             SDCURRPD/A6CYCD)) MAPFLD((SSNB A6SSNB) +
                             (INCY A6INCY))   ***/             /*CEU012 180788*/
/***********    CPYFRMQRYF FROMOPNID(OLPOSOA) TOFILE(GLOLEMPD) +
                             MBROPT(*REPLACE)   ***/           /*CEU012 180788*/
/***********    MONMSG     MSGID(CPF2909)                      /*CEU012 180788*/
/***********    CLOF       OPNID(OLPOSOA)                      /*CEU012 180788*/
/***********    DLTOVR     FILE(GLOLEMPD)                      /*CEU012 180788*/
/***********    MONMSG     MSGID(CPF0000)                      /*CEU012 180788*/
             ENDDO                                                    /*CEU012*/
/*                                                                            */
             CALL       PGM(DL0150)
/**/
/** reset status messages to user profile's default:                 */
             CHGJOB     STSMSG(*USRPRF)
/*                                                        End DT0174 */
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(&JOB)
             ENDDO
EXIT:                                                                 /*CEU012*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
