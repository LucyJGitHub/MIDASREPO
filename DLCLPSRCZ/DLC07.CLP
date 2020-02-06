/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Spot revaluation')                           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC07 - SPOT REVALUATION                                   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       PREV AMEND. 142919                  DATE 09MAY01           */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                   S01408                  DATE 18NOV96           */
/*                   S01408                  DATE 26JUL96           */
/*                   S01408                  DATE 08MAY96           */
/*                   E243                    DATE 26FEB90           */
/*                   S01117                  DATE 18/04/89          */
/*                   S01194                  DATE 18/04/89          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       142919 - When Analytical Accounting module is *ON, do not  */
/*                run DL0450.                                       */
/*                AOMMODR0 should be called with &OPTN(*FREE) in    */
/*                order to retrive the current value of MMOD.       */
/*       S01408 - Addition of core hook DLC07005                    */
/*       S01408 - Addition of core hook DLC07MPS                    */
/*              - Addition of core hook DLC07MPE                    */
/*              - Addition of core hook DLC07ERR                    */
/*              - Addition of core hook DLC07END                    */
/*              - Addition of core hook DLC07002                    */
/*              - Addition of core hook DLC07003                    */
/*              - Addition of core hook DLC07004                    */
/*         Note - added ABNOR processing etc to allow addition of   */
/*                these /COPY members in the correct positions.     */
/*       S01408 - Addition of core hook DLC07001                    */
/*                Addition of core hook DLC07INT                    */
/*       E243   - INCORRECT PARAMETERS ON CALL TO PROGRAM           */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - STANDING DATA CHANGES.                            */
/********************************************************************/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC07005                                             /*S01408*/
/**/                                                                  /*S01408*/
/*********** PGM                                                      /*S01117*/
/************PGM PARM(&RSEQ &RLEV &RENT)                    /*S01117* /*E243*/
             PGM                                                      /*S01117*/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07INT                                              *S01408*/
/*                                                                     *S01408*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**DCL*VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number * *S01117 /*E243*/
/**DCL*VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B *S01117 /*E243*/
/**DCL*VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/ *S01117 /*E243*/
             DCL   VAR(&SWS) TYPE(*CHAR)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01408*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FREE  ') /*142919*/
             DCL       VAR(&FMT)  TYPE(*CHAR) LEN(800)                /*142919*/
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*142919*/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07002                                              *S01408*/
/*                                                                     *S01408*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)       /*S01408*/
/**/
             CHGJOB     SWS(00000000)
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07MPS                                              *S01408*/
/*                                                                     *S01408*/
             SNDMSG     MSG('Spot Revaluations')  TOMSGQ(MRUNQ)
             CLRPFM     FILE(GESRHH)
             CLRPFM     FILE(GESRPD)
             CLRPFM     FILE(GESRZZ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)                 /*S01194*/
/*********** OVRDBF     FILE(TABLE2)  TOFILE(TABDLEE)                 /*S01194*/
/**/
/*********** CALL       PGM(DL0450)                                   /*S01117*/
/*********** CALL       PGM(DL0450) PARM(&RSEQ)             /*S01117* /*E243*/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07003                                              *S01408*/
/*                                                                     *S01408*/
/* */                                                                 /*142919*/
/** Access PF/SDMMODPD, With *FREE first, then *FIRST.                /*142919*/
/* */                                                                 /*142919*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*142919*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*142919*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*142919*/
             IF         COND(%SST(&FMT 100 1) *NE 'Y') THEN(DO)       /*142919*/
             CALL       PGM(DL0450)                                   /*S01117*/
             ENDDO                                                    /*142919*/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07004                                              *S01408*/
/**/
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE TABLE2)                            /*S01194*/
/**/
             IF         COND(%SST(&SWS 7 2) *NE '00') THEN(GOTO +
                          CMDLBL(ABNOR))                              /*S01408*/
/************IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
/************           MSG('JOB TERMINATED - DATABASE IN ERROR') +
/************           TOMSGQ(MOPERQ))                               /*S01408*/
/************IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
/************           MSG('FILE CONTROLS OUT OF BALANCE') +
/************           TOMSGQ(MOPERQ))                               /*S01408*/
/**/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07MPE                                              *S01408*/
/*                                                                     *S01408*/
             GOTO       CMDLBL(END)                                   /*S01408*/
/*                                                                     *S01408*/
ABNOR:                                                                /*S01408*/
/*/COPY WNCPYSRC,DLC07ERR                                              *S01408*/
/*                                                                     *S01408*/
             IF         COND(%SST(&SWS 7 1) *NE '0') THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01408*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*S01408*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)                      /*S01408*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*S01408*/
             ENDDO                                                    /*S01408*/
                                                                      /*S01408*/
             SNDPGMMSG  MSG('DLC07 - Spot Revaluation TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01408*/
                                                                      /*S01408*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01408*/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01408*/
/*                                                                     *S01408*/
/*/COPY WNCPYSRC,DLC07001                                              *S01408*/
/*                                                                     *S01408*/
END:                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC07END                                              *S01408*/
/*                                                                     *S01408*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
