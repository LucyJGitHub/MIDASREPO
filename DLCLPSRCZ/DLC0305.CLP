/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Currency Position By Date Enq.')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0305 - CURRENCY POSITION BY DATE ENQUIRY                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. 244262             Date 12Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. 180788             Date 30Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU012             Date 16Feb98              */
/*                      S01194             Date 01Aug89              */
/*                                                                  */
/********************************************************************/
/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*                                                                  */
/*       244262 - CPF5149 in file OLPOS1 when FCPD is used after     */
/*                using FCPS.                                        */
/*       180788 - Allow more than two users to access the Foreign    */
/*                Currency Positions Enquiry Graph at the same time. */
/*       CEU012 - EMU Position/Risk Enquiries                       */
/*       S01194  -  NEW STANDING DATA                               */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/                                                                  /*CEU012*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU012*/
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(1)               /*CEU012*/
             DCL        VAR(&EURO) TYPE(*CHAR) LEN(1)                 /*CEU012*/
/**/                                                                  /*CEU012*/
/**/
             CHGJOB     SWS(00000000)
/**/                                                                  /*CEU012*/
/* Check if CEU012 is installed */                                    /*CEU012*/
/**/                                                                  /*CEU012*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU012*/
             CHGVAR     VAR(&SARD) VALUE('CEU012')                    /*CEU012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CEU012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU012) VALUE('Y'))                    /*CEU012*/
/**/                                                                  /*CEU012*/
/* DB Error */                                                        /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU012*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU012*/
               CHGJOB (XXXXXX11)                                      /*CEU012*/
               GOTO       CMDLBL(END)                                 /*CEU012*/
             ENDDO                                                    /*CEU012*/
/**/                                                                  /*CEU012*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                   /*S01194*/
/**/                                                                  /*CEU012*/
/* If CEU012 is installed, build a query file to retrieve the sort */ /*CEU012*/
/*    sequence number and the 'In' currency indicator.             */ /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&CEU012 *EQ 'Y') THEN(DO)                /*CEU012*/
/***********   OVRDBF     FILE(GLOLEMPD) SHARE(*NO)   ***/     /*CEU012 180788*/
               OVRDBF     FILE(GLOLPEL1) TOFILE(OLPOS4) +
                            SHARE(*YES)                               /*180788*/
               OVRDBF     FILE(GLOLPEL2) TOFILE(OLPOS5) +
                            SHARE(*YES)                               /*180788*/
/***********   MONMSG     MSGID(CPF0000)   ***/                /*CEU012 180788*/
/***********   OPNQRYF    FILE((OLPOSOA) (SDCURRPD) (SDGELRPD)) +
                            FORMAT(GLOLEMPD) KEYFLD((INCY) (SSNB)) +
                            JFLD((OLPOSOA/CCY SDCURRPD/A6CYCD)) +
                            JDFTVAL(*YES) MAPFLD((SSNB '2/A6SSNB') +
                            (INCY '2/A6INCY'))   ***/          /*CEU012 180788*/
/*********** CPYFRMQRYF FROMOPNID(OLPOSOA) TOFILE(GLOLEMPD) +
                          MBROPT(*REPLACE)   ***/              /*CEU012 180788*/
/***********   MONMSG     MSGID(CPF2909)   ***/                /*CEU012 180788*/
/***********   CLOF       OPNID(OLPOSOA)   ***/                /*CEU012 180788*/
/***********   DLTOVR     FILE(GLOLEMPD)   ***/                /*CEU012 180788*/
             ENDDO                                                    /*CEU012*/
/**/                                                                  /*CEU012*/
             OVRDBF     FILE(OLPOS1) SHARE(*YES)                                          /*244262*/
             CLOF       OLPOS1                                                            /*244262*/
             MONMSG     MSGID(CPF0000)                                                    /*244262*/
             CALL       PGM(DL0160)
/************DLTOVR     FILE(TABLE)                                  /*S01194*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(&JOB)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/************ENDPGM                                                */ /*CEU012*/
END:         ENDPGM                                                   /*CEU012*/
