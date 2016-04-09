/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Overrides for foreign currency graphs')      */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC5709 - OVERRIDES FOR FOREIGN CURRENCY GRAPHS            */
/*                (USED BY SECURITY PROFILE FACILITY)               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. 180788             Date 30Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU012             Date 16Feb98              */
/*                      S01194             Date 11Aug89              */
/*                      E14948             Date 04Nov88              */
/*                      E16261             Date 02Dec88              */
/*                                                                   */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/*       180788 - Allow more than two users to access the Foreign    */
/*                Currency Positions Enquiry Graph at the same time. */
/*       CEU012 - EMU Position/Risk Enquiry                          */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       E14948  -  SWITCHES U7 & U8 WERE NOT BEING SET OFF BEFORE  */
/*                  RPG PROGRAMS WERE CALLED                        */
/*       E16261  -  PROGRAM WAS NOT CHECKING FOR DATABASE ERROR     */
/*                  (SWITCHES 7 & 8 BEING SET ON BY THE CALLED      */
/*                  PROGRAM) AFTER CALLING DL1300 & DL1310          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&OPT)
 
                                                        /*E16261*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
                                                        /*E16261*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*CEU012*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU012*/
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(1)               /*CEU012*/
 
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
/************OVRDBF     FILE(TABLD) TOFILE(TABDLI) SHARE(*NO)         /*S01194*/
 
                                                        /* E14948 */
             CHGJOB     SWS(XXXXXX00)
                                                        /* E14948 */
                                                                      /*CEU012*/
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
               OVRDBF     FILE(GLOLPEL1) TOFILE(OLPOS4) +
                            SHARE(*YES)                               /*180788*/
               OVRDBF     FILE(GLOLPEL2) TOFILE(OLPOS5) +
                            SHARE(*YES)                               /*180788*/
/***********   OPNQRYF    FILE((OLPOSOA) (SDCURRPD)) FORMAT(GLOLEMPD) +
                          KEYFLD((*MAPFLD/SSNB *ASCEND) +
                          (OLPOSOA/CCY)) JFLD((OLPOSOA/CCY +
                          SDCURRPD/A6CYCD)) MAPFLD((SSNB A6SSNB) +
                          (INCY A6INCY))   ***/                /*CEU012 180788*/
/***********   CPYFRMQRYF FROMOPNID(OLPOSOA) TOFILE(GLOLEMPD) +
                            MBROPT(*REPLACE)   ***/            /*CEU012 180788*/
/***********   MONMSG     MSGID(CPF2909)   ***/                /*CEU012 180788*/
/***********   CLOF       OPNID(OLPOSOA)   ***/                /*CEU012 180788*/
             ENDDO                                                    /*CEU012*/
             IF         COND(&OPT *EQ '1') THEN(CALL PGM(DL1310))
             ELSE       CMD(CALL PGM(DL1300))
 
/************DLTOVR     FILE(TABLE TABLD)                             /*S01194*/
 
                                                        /*E16261*/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                          (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                          TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                          TOMSGQ(&JOB)
                          ENDDO
                                                        /*E16261*/
END:                                                                  /*CEU012*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
