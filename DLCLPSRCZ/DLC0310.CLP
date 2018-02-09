/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CURRENCY POSITION BY DATE GRAPH')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0310 - POSITIONS BY DATE ENQUIRY - GRAPH                */
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
/*       Prev Amend No. CEU012             Date 16Feb98              */
/*                      S01194             Date 11/08/89             */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CEU012 - EMU Position/Risk Enquiry                          */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(1)               /*CEU012*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU012*/
             CHGVAR     VAR(&SARD) VALUE('CEU012')                    /*CEU012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CEU012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU012) VALUE('Y'))                    /*CEU012*/
/**/                                                                  /*CEU012*/
/* Error */                                                           /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU012*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU012*/
               CHGJOB (XXXXXX11)                                      /*CEU012*/
               GOTO       CMDLBL(END)                                 /*CEU012*/
             ENDDO                                                    /*CEU012*/
             IF         COND(&CEU012 *EQ 'Y') THEN(DO)                /*CEU012*/
               OPNQRYF    FILE((OLPOSOA) (SDCURRPD)) FORMAT(GLOLEMPD) +
                            KEYFLD((*MAPFLD/SSNB *ASCEND) +
                            (OLPOSOA/CCY)) JFLD((OLPOSOA/CCY +
                            SDCURRPD/A6CYCD)) MAPFLD((SSNB A6SSNB) +
                            (INCY A6INCY))                            /*CEU012*/
               CPYFRMQRYF FROMOPNID(OLPOSOA) TOFILE(GLOLEMPD) +
                            MBROPT(*REPLACE)                          /*CEU012*/
               MONMSG     MSGID(CPF2909)                              /*CEU012*/
               CLOF       OPNID(OLPOSOA)                              /*CEU012*/
             ENDDO                                                    /*CEU012*/
                                                                      /*CEU012*/
             CALL       PGM(DL1310)
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
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:                                                                  /*CEU012*/
             ENDPGM
