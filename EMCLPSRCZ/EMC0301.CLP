/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Customer limits/exposure/avail')             */
/********************************************************************/
/*                                                                  */
/*        Midas - Exposure Management Module                        */
/*                                                                  */
/*      EMC0301 EXPOSURE/LIMIT/AVAILABILITY BY CUSTOMER             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD053498           Date 13Apr20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      090890             Date 19Feb96              */
/*                       S01408            Date 20JUN95              */
/*                      083857           DATE  20APR95              */
/*                      S01473           DATE  03NOV94              */
/*                      S01474           DATE  25JUL94              */
/*                      E27940           DATE  03SEP91              */
/*                      S01311           DATE  07MAR91              */
/*                      S01194           DATE  13DEC89              */
/*                      E17912           DATE  14/04/89             */
/*                      E13911           DATE  29/06/88             */
/*                      E80946           DATE  28/11/86             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD053498 - MM-Limit not displayed in "Exposure by customer/*/
/*                  parent enquiry" menu when S01433 is ON.         */
/*                  Fix is to introduce new logical files which will*/
/*                  hold the MM-Limit. New files will be used only  */
/*                  when S01433 is switched on.                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*      090890 - PROBLEM WITH MIDAS/LEO INTERFACE.                  */
/*               IT USES *LDA FOR TRANFERRING LIBRARY NAMES BUT     */
/*               THE POSITIONS IT USED IN *LDA ARE ALSO USED BY THE */
/*               CALLED PROGRAM GL4443 FOR OTHER INFORMATION!       */
/*               DEFINITION OF *LDA IS MODIFIED SO THAT OVERLAPPING */
/*               OF USAGE (OF *LDA) IS AVOIDED.                     */
/*      S01408 - Addition of core hooks EMC0301MP1                  */
/*                                      EMC0301MP2                  */
/*      083857 - Field added for 'EM Interface Credit Line Code'.   */
/*      S01473 - Leo Midas Integration: CLCD42 can be called through*/
/*               LE0161 through this program, without ever going    */
/*               through LEC0301 to set up all the necessary bits.  */
/*      S01474 - Leo Midas Integration. Display Leo Customer        */
/*               Exposure.                                          */
/*       E27940 - SESDS SHOULD BE 37 CHARACTERS LONG                */
/*       S01311 - Program amended for Exposure Management           */
/*                Release 10 to create data  areas                  */
/*       S01194 - STANDING DATA CHANGES                             */
/*      E17912 - DATA AREA SESDS ONLY CREATED IF SE MODULE PRESENT  *  *E17912*/
/*               BECAUSE OF E16158 IT MUST ALWAYS BE CREATED.       *  *E17912*/
/*      E13911 - POST INCORPORATION FIX (SE) FROM DEVELOPMENT.      *  *E13911*/
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&SEMOD) TYPE(*CHAR) LEN(1)                /*E13911*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01474*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01474') /*S01474*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01474*/
             DCL        VAR(&S01474) TYPE(*CHAR) LEN(1)               /*S01474*/
             DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)               /*S01473*/
             DCL        VAR(&S01433) TYPE(*CHAR) LEN(1)                                 /*MD053498*/
             DCL        VAR(&LINEXP) TYPE(*CHAR) LEN(1)               /*S01474*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('  DMLIB')                            /*S01474*/
             DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('  LDLIB')                            /*S01474*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10) +
                          VALUE('  DTALIB')                           /*S01474*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)                  /*S01474*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)                /*S01474*/
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(10)                /*S01474*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,EMC0301001                                          */
/**/
             CHGJOB SWS(00000000)
/**/
             RTVDTAARA  DTAARA(MMOD (21 1)) RTNVAR(&SEMOD)            /*E13911*/
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CHKOBJ     OBJ(QTEMP/EMSDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
/**********  CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161)     */                   /*CGL029*/
             CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                          /*CGL029*/
             ENDDO
             CHGDTAARA  DTAARA(QTEMP/EMSDS) VALUE(' ')
                                                            /*S01311*/
/*  If DLSDS data area not present then create it */

             CHKOBJ     OBJ(QTEMP/DLSDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */                   /*CGL029*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                          /*CGL029*/
             ENDDO
             CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')

                                                            /*S01311*/
/**/                                                                  /*E13911*/
/*  IF THE SE MODULE IS PRESENT, CREATE THE DATA-AREA SESDS (IF IT  *  *E13911*/
/*   DOESN'T ALREADY EXIST).                                        *  *E13911*/
/**/                                                                  /*E13911*/
/************IF         COND(&SEMOD *EQ 'Y') THEN(DO)   */ /*E13911*/ /*E17912*/
                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                /*E13911*/
                MONMSG     MSGID(CPF9800) EXEC(DO)                    /*E13911*/
/************CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(36) + */ /*E27940*/
/************             /*E13911*/                                 /*E27940*/
/************ENDDO                                      */ /*E13911*/ /*E17912*/
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)      /*E27940*/
/**/                                                                  /*E13911*/
/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.        *  *E13911*/
/*                     AND SET ZONED FIELDS                         *  *E13911*/
/**/                                                                  /*E13911*/
                CHGDTAARA  DTAARA(SESDS) VALUE(' ')                   /*E13911*/
                CHGDTAARA  DTAARA(SESDS (1 6)) VALUE('EM0301')        /*E13911*/
                CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')    /*E13911*/
             ENDDO                                                    /*E13911*/
                                                                      /*S01474*/
/* Check if Leo Enhancement no. is on the switchable features file */ /*S01474*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01474*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01474) VALUE('Y'))                    /*S01474*/
                                                                      /*S01473*/
/* Check if Leo Enhancement no. is on the switchable features file */ /*S01473*/
             CHGVAR     VAR(&SARD) VALUE('S01473')                    /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*S01473*/
                                                                                        /*MD053498*/
/* Check if Enhanced Dealing Limits (S01433) is switched on */                          /*MD053498*/
             CHGVAR     VAR(&SARD) VALUE('S01433')                                      /*MD053498*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                      /*MD053498*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR VAR(&S01433) +
                          VALUE('Y'))                                                   /*MD053498*/
                                                                      /*S01474*/
/* If the feature is present, override the Leo files to the files +
   on the Leo system */                                               /*S01474*/
/************IF         COND(&S01474 *EQ 'Y') THEN(DO)**************/ /*S01474*/
             IF         COND((&S01474 *EQ 'Y') *OR (&S01473 *EQ +
                          'Y')) THEN(DO)                              /*S01474*/
/* Retrieve the data area containing the Leo system Prefix into a  +
   variable. (Hence &PREF = Library list Prefix) */                   /*S01474*/
                RTVDTAARA  DTAARA(LOPREF *ALL) RTNVAR(&PREF)          /*S01474*/
                                                                      /*S01474*/
/* If either position is blank, this is an error */                   /*S01474*/
             IF         COND((%SST(&PREF 1 1) *EQ ' ') *OR +
                          (%SST(&PREF 2 1) *EQ ' ')) THEN(DO)         /*S01474*/
                                                                      /*S01474*/
/* If it is, send message and terminate */                            /*S01474*/
             CHGVAR     VAR(&MESSAGE) VALUE('The Leo Prefix data +
                          area has not been set up')                  /*S01474*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*S01474*/
             CALL       PGM(SCC0010) PARM('EMC0301' 'ENTER' ' ')      /*S01474*/
             GOTO       CMDLBL(END)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
/* Set up the names of the Leo DMLIB, LDLIB and DTALIB using the  +
   system prefix so the files can be overriden  */                    /*S01474*/
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&PREF)            /*S01474*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EMC0301MP1                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(%SST(&LDLIB 1 2)) VALUE(&PREF)            /*S01474*/
             CHGVAR     VAR(%SST(&DTALIB 1 2)) VALUE(&PREF)           /*S01474*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EMC0301MP2                                          */
                                                                      /*S01408*/
                                                                      /*S01474*/
/* Override the files required by the RPG to the Leo libraries */     /*S01474*/
             OVRDBF     FILE(FDRAW) TOFILE(&LDLIB/FDRAW)              /*S01473*/
             OVRDBF     FILE(TBCCY) TOFILE(&DMLIB/TBCCY)              /*S01473*/
             OVRDBF     FILE(TBSC) TOFILE(&DMLIB/TBSC)                /*S01473*/
             OVRDBF     FILE(TBPCL) TOFILE(&DMLIB/TBPCL)              /*S01473*/
             OVRDBF     FILE(TBCL) TOFILE(&DMLIB/TBCL)                /*S01474*/
             OVRDBF     FILE(CUSPRO) TOFILE(&DMLIB/CUSPRO)            /*S01474*/
             OVRDBF     FILE(LIACRN) TOFILE(&LDLIB/LIACRN)            /*S01474*/
             OVRDBF     FILE(LINES) TOFILE(&DMLIB/LINES)              /*S01474*/
             OVRDBF     FILE(LIGRP) TOFILE(&LDLIB/LIGRP)              /*S01474*/
             OVRDBF     FILE(CPACRN) TOFILE(&LDLIB/CPACRN)            /*S01474*/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&DTALIB/CMSG03)         /*S01474*/
                                                                      /*S01474*/
/**Clear*the*data area from positions 51 to 80 */          /*S01474*/ /*083857*/
/************CHGDTAARA  DTAARA(*LDA (51 40)) VALUE(' ') */ /*S01474*/ /*083857*/
/**Clear*the*data*area*from*positions*51*to*100**/             /*083857 090890*/
/*********** CHGDTAARA  DTAARA(*LDA (51 50)) VALUE(' ')*/      /*083857 090890*/
/* Clear the data area from positions 61 to 110 */                    /*090890*/
             CHGDTAARA  DTAARA(*LDA (61 50)) VALUE(' ')               /*090890*/
                                                                      /*S01474*/
/* Locate the Leo programs used by the RPG program via the Midas +
   program SCC1110. Place the returned libraries in the *LDA for +
   use by the called RPG program CSTD10   */                          /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CSTD10' &LIBL)             /*S01474*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01474*/
/*********** CHGDTAARA  DTAARA(*LDA (51 10)) VALUE(&LIBL)*/    /*S01474 090890*/
             CHGDTAARA  DTAARA(*LDA (61 10)) VALUE(&LIBL)             /*090890*/
             ENDDO                                                    /*S01474*/
             ELSE       CMD(DO)                                       /*S01474*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01474*/
             GOTO       CMDLBL(MSG)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CAOUCU' &LIBL)             /*S01474*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01474*/
/*********** CHGDTAARA  DTAARA(*LDA (61 10)) VALUE(&LIBL)*/    /*S01474 090890*/
             CHGDTAARA  DTAARA(*LDA (71 10)) VALUE(&LIBL)             /*090890*/
             ENDDO                                                    /*S01474*/
             ELSE       CMD(DO)                                       /*S01474*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01474*/
             GOTO       CMDLBL(MSG)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CAOULI' &LIBL)             /*S01474*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01474*/
/*********** CHGDTAARA  DTAARA(*LDA (71 10)) VALUE(&LIBL)*/    /*S01474 090890*/
             CHGDTAARA  DTAARA(*LDA (91 10)) VALUE(&LIBL)             /*090890*/
             ENDDO                                                    /*S01474*/
             ELSE       CMD(DO)                                       /*S01474*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01474*/
             GOTO       CMDLBL(MSG)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CSTD10FM' &LIBL)           /*S01474*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01474*/
             OVRDSPF    FILE(CSTD10FM) TOFILE(&LIBL/CSTD10FM)         /*S01474*/
             ENDDO                                                    /*S01474*/
             ELSE       CMD(DO)                                       /*S01474*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01474*/
             GOTO       CMDLBL(MSG)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CSTDHELP' &LIBL)           /*S01474*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01474*/
/* CAN'T OVERRIDE SO COPY HELP TEXT INTO QTEMP IF NOT THERE ALREADY*/ /*S01474*/
             CHKOBJ     OBJ(QTEMP/CSTDHELP) OBJTYPE(*FILE)            /*S01474*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                       /*S01474*/
             CRTDUPOBJ  OBJ(CSTDHELP) FROMLIB(&LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)                                /*S01474*/
             MONMSG     MSGID(CPF2130) /* NOT AUTHORISED */           /*S01474*/
             ENDDO                                                    /*S01474*/
             ENDDO                                                    /*S01474*/
             ELSE       CMD(DO)                                       /*S01474*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01474*/
             GOTO       CMDLBL(MSG)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                      /*S01474*/
             RTVDTAARA  DTAARA(&DTALIB/LINEXP (1 1)) RTNVAR(&LINEXP)  /*S01474*/
             MONMSG     MSGID(CPF1015) EXEC(CHGVAR VAR(&LINEXP) +
                          VALUE(' '))                                 /*S01474*/
             CRTDTAARA  DTAARA(QTEMP/LINEXP) TYPE(*CHAR) LEN(1) +
                          VALUE(&LINEXP) TEXT('Temporary copy of +
                          Leo data area')                             /*S01474*/
                                                                      /*S01474*/
             CALL       PGM(SCC1110) PARM('CLCD42' &LIBL)             /*S01473*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01473*/
             CHGDTAARA  DTAARA(*LDA (81 10)) VALUE(&LIBL)             /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01473*/
             GOTO       CMDLBL(MSG)                                   /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(SCC1110) PARM('CLCD42FM' &LIBL)           /*S01473*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01473*/
             OVRDSPF    FILE(CLCD42FM) TOFILE(&LIBL/CLCD42FM)         /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01473*/
             GOTO       CMDLBL(MSG)                                   /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(SCC1110) PARM('CAOUSC' &LIBL)             /*083857*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*083857*/
/*********** CHGDTAARA  DTAARA(*LDA (91 10)) VALUE(&LIBL)*/    /*083857 090890*/
             CHGDTAARA  DTAARA(*LDA (101 10)) VALUE(&LIBL)            /*090890*/
             ENDDO                                                    /*083857*/
             ELSE       CMD(DO)                                       /*083857*/
                CHGVAR     VAR(&ERR) VALUE('Y')                       /*083857*/
                GOTO       CMDLBL(MSG)                                /*083857*/
             ENDDO                                                    /*083857*/
                                                                      /*083857*/
MSG:         IF         COND(&ERR *EQ 'Y') THEN(DO)                   /*S01474*/
/* Send an error message and terminate */                             /*S01474*/
             CHGVAR     VAR(&MESSAGE) VALUE('One or more Leo +
                          programs cannot be located')                /*S01474*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*S01474*/
             CALL       PGM(SCC0010) PARM('EMC0301' 'ENTER' ' ')      /*S01474*/
             GOTO       CMDLBL(END)                                   /*S01474*/
             ENDDO                                                    /*S01474*/
             ENDDO                                                    /*S01474*/
                                                                                        /*MD053498*/
             IF         COND(&S01433 *EQ 'Y') THEN(DO)                                  /*MD053498*/
                OVRDBF     FILE(EMCEJ) TOFILE(EMCEJ4)                                   /*MD053498*/
                OVRDBF     FILE(EMCEJ2) TOFILE(EMCEJ5)                                  /*MD053498*/
                OVRDBF     FILE(EMCEJ3) TOFILE(EMCEJ6)                                  /*MD053498*/
             ENDDO                                                                      /*MD053498*/
                                                                                        /*MD053498*/
/*/COPY WNCPYSRC,EMC0301003                                          */
/**/
             CALL       EM0301
/**/
/*/COPY WNCPYSRC,EMC0301004                                          */
             RCLRSC                                                   /*E80946*/
/**/
             DLTOVR     FILE(TABLE)
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
              IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44)) */           /*S01194*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01194*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
              ENDDO
/**/
END:                                                                  /*S01474*/
/* If the feature S01474 is present, remove the file overrides, +
/* and clear the data area from positions 51 to 80  */                /*S01474*/
/************IF         COND(&S01474 *EQ 'Y') THEN(DO)**************/ /*S01474*/
             IF         COND((&S01474 *EQ 'Y') *OR (&S01473 *EQ +
                          'Y')) THEN(DO)                              /*S01473*/
                DLTOVR     FILE(*ALL)                                 /*S01474*/
/***************CHGDTAARA  DTAARA(*LDA (51 80)) VALUE(' ') /*S01474*/ /*083857*/
/***********    CHGDTAARA  DTAARA(*LDA (51 50)) VALUE(' ')*/   /*083857 090890*/
                CHGDTAARA  DTAARA(*LDA (61 50)) VALUE(' ')            /*090890*/
                DLTDTAARA  DTAARA(QTEMP/LINEXP)                       /*S01474*/
                MONMSG     MSGID(CPF2105)                             /*083857*/
             ENDDO                                                    /*S01474*/
/*/COPY WNCPYSRC,EMC0301002                                          */
                                                                      /*S01474*/
             IF         COND(&S01433 *EQ 'Y') THEN(DO)                                  /*MD053498*/
             DLTOVR     FILE(*ALL)                                                      /*MD053498*/
             ENDDO                                                                      /*MD053498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
           ENDPGM
