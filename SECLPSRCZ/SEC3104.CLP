/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Daily Changes Updat Control')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                        */
/*                                                                  */
/*     SEC3104 - EXTEL DAILY CHANGES UPDATE CONTROL                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     Last Amend No. CPK009            Date  09Aug99               */
/*     Prev Amend No. S01117            DATE  10JAN91               */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*                                                                  */
/********************************************************************/
 
/********************************************************************/
/*                                                                  */
/*  Note:   The EXTEL status (&STS) is continually changed to       */
/*          facilitate restart.                                     */
/*                                                                  */
/*   C  -   Data reception complete                                 */
/*   I  -   Historic Index Values Update                            */
/*   P  -   Prices update                                           */
/*   D  -   EXTEL Database Update                                   */
/*   V  -   EXTEL Price Validation Purge                            */
/*   F  -   EXTEL processing finished                               */
/*                                                                  */
/********************************************************************/
     PGM      PARM(&RST)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
     DCL      &STS     *CHAR    1       /* STATUS CODE                  */
     DCL      &PIN     *CHAR    1       /* PRICES IND                   */
/****DCL      &MEM     *CHAR   44       /* DATABASE ERROR MESSAGE      *S01117*/
     DCL      &MEM     *CHAR   50       /* DATABASE ERROR MESSAGE      *S01117*/
/****DCL      &MIM     *CHAR    8       /* UNBALANCED FILES PROGRAM    *S01117*/
     DCL      &MIM     *CHAR   10       /* UNBALANCED FILES PROGRAM    *S01117*/
     DCL      &RST     *CHAR    7       /* RESTART OR NOT               */
     DCL      &SQNR    *DEC     3 0     /* Sequence number              */
     DCL      &SQNRA   *CHAR    3       /* Sequence number (alpha)      */
     DCL      &EXEF    *CHAR    1       /* EXTEL error flag             */
     DCL      &MNTF    *CHAR    1       /* Maintenance flag             */
 
 
 
      SNDPGMMSG  MSG('SEC3104 - EXTEL Daily Changes Update in +
                          Progress') TOMSGQ(MOPERQ)
 
/*   If job submitted to batch begin commitment control                 */
 
     IF      COND(&RST *EQ '       ')  THEN(DO)
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))               /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                 /*CPK009*/
             ENDDO
 
/*   End if in input cycle and data reception not complete              */
 
     RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&STS)
 
     IF      COND((&RST *EQ 'INPUT/C') *AND (&STS *NE 'C')) THEN(DO)
             SNDPGMMSG  MSG('Option not valid') TOPGMQ(*EXT) +
              TOMSGQ(MOPERQ)
             GOTO  ENDPGM
             ENDDO
 
/*   If flag is N then change to Y so Maintenance not available         +
        while updates in progress                                       */
 
     RTVDTAARA  DTAARA(EXSTAT (146 1)) RTNVAR(&MNTF)
     IF         COND(&MNTF *EQ 'N')    THEN(DO)              /*  B1  */
                CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(Y)
     ENDDO                                                   /*  E1  */
 
/*   If RESTART skip to MAIN processing                                 */
 
     RTVDTAARA  DTAARA(EXSTAT (77 1)) RTNVAR(&EXEF)
 
     IF      COND(&RST *EQ 'RESTART') THEN(DO)                 /*B1*/
             IF      COND(&EXEF *NE 'Y') THEN(DO)              /*B2*/
                     SNDPGMMSG  MSG('Restart Option not valid') +
                      TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
                     GOTO  ENDPGM
                     ENDDO                                     /*E2*/
             ELSE    GOTO MAIN
             ENDDO                                             /*E1*/
 
/*----------------------------------------------------------------------*/
 
/*   Access data area EXSTAT - EXTEL Interface control                  */
 
LOOP:                                                      /*  LOOP  */
 
/*   If flag is E then END (program cancel initiated)                   */
 
     RTVDTAARA  DTAARA(EXSTAT (146 1)) RTNVAR(&MNTF)
     IF         COND(&MNTF *EQ 'E')    THEN(DO)              /*  B1  */
                CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(N)
                GOTO       ENDPGM
     ENDDO                                                   /*  E1  */
 
/*   If status is not C then loop                                       */
 
     RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&STS)
     IF      COND(&STS *NE 'C')  THEN(DO)                    /*  B1  */
             DLYJOB     DLY(60)
             GOTO       LOOP
     ENDDO                                                   /*  E1  */
 
/*----------------------------------------------------------------------*/
 
/*   Set switches off                                                   */
 
MAIN:        CHGJOB     SWS(00000000)
 
/*----------------------------------------------------------------------*/
 
 
/*   Set status to I for INDEX Updating                                 */
 
     IF      COND(&STS *EQ 'C')  THEN(DO)                    /*  B1  */
             CHGDTAARA  DTAARA(EXSTAT (76 1)) VALUE(I)
             CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('HISTORIC INDEX +
                          VALUES UPDATE')
             CHGVAR     VAR(&STS) VALUE(I)
     ENDDO                                                   /*  E1  */
 
/*----------------------------------------------------------------------*/
 
/*   Process if Status is I                                             */
 
     IF      COND(&STS *EQ 'I')  THEN(DO)                    /*  B1  */
 
/*   Send message to MOPERQ to inform of start of SE3103                */
 
             SNDPGMMSG  MSG('SE3103 - Historic Index Values  +
                            Update in Progress') TOMSGQ(MOPERQ)
 
/*   Call SE3103 - History Index Values Update                          */
 
             CALL       SE3103
 
/*   If U7 or U8 on process error                                       */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ERROR)
 
/*   Change status to P for Prices programs                             */
 
             CHGDTAARA  DTAARA(EXSTAT (76 1)) VALUE(P)
             CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('EXTEL PRICES +
                          UPDATE')
             CHGVAR     VAR(&STS) VALUE(P)
 
 
     ENDDO                                                     /* E1 */
 
/*----------------------------------------------------------------------*/
 
/*   Process if Status is P and Prices Ind. is Y                        */
 
     RTVDTAARA  DTAARA(EXSTAT (21 1)) RTNVAR(&PIN)
 
     IF         COND((&STS *EQ 'P') *AND (&PIN *EQ 'Y')) THEN(DO)
 
/*   Send message to MOPERQ to inform of start of SE3104                */
 
                SNDPGMMSG  MSG('SE3104 - EXTEL Prices Update in +
                          Progress') TOMSGQ(MOPERQ)
 
/*   Clear EXTEL price file                                             */
 
             CLRPFM     EXPRCD
 
/*   Call SE3104 - EXTEL Prices Update                                  */
 
             CALL       SE3104
 
/*   If U7 or U8 on process error                                       */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ERROR)
 
/*   Change narrative for Prices Audit                                  */
 
             CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('EXTEL PRICES +
                          AUDIT LIST')
 
/*   Call SE3105 - EXTEL Prices Audit                                   */
 
             CALL       SE3105
 
/*   If U7 or U8 on process error                                       */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ERROR)
 
/*   Change status to D for EXTEL database update                       */
 
             CHGDTAARA  DTAARA(EXSTAT (76 1)) VALUE(D)
             CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('EXTEL +
                          DATABASE UPDATE')
 /***********CHGVAR     VAR(&STS) VALUE(D)*****  TEST  *******/
             CHGVAR     VAR(&STS) VALUE(V)
 
     ENDDO                                                   /*  E1  */
 
/*----------------------------------------------------------------------*/
 
/*   Process if Status is D                                             */
 
     IF      COND(&STS *EQ 'D')  THEN(DO)                    /*  B1  */
 
/*   Send message to MOPERQ to inform of start of SE3101                */
 
             SNDPGMMSG  MSG('SE3101 - EXTEL Database Update +
                             in Progress') TOMSGQ(MOPERQ)
 
/*   Call SE3101 - EXTEL Database Update                                */
 
             CALL       SE3101
 
/*   If U7 or U8 on process error                                       */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ERROR)
 
/*   Change status to V for EXTEL Price Validation Purge                */
 
             CHGDTAARA  DTAARA(EXSTAT (76 1)) VALUE(V)
             CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('EXTEL PRICE +
                          VALIDATION PURGE')
             CHGVAR     VAR(&STS) VALUE(V)
 
     ENDDO                                                   /*  E1  */
 
/*----------------------------------------------------------------------*/
 
/*   Process if Status is V                                             */
 
     IF      COND(&STS *EQ 'V')  THEN(DO)                    /*  B1  */
 
/*   Send message to MOPERQ to inform of start of SE3102                */
 
             SNDPGMMSG  MSG('SE3102 - EXTEL Price Validation Purge +
                             in Progress') TOMSGQ(MOPERQ)
 
/*      Clear the existing NEW EXTEL price validation files.            */
 
        CLRPFM     NEXVALD
        CLRPFM     NEXVALZ
 
/*   Call SE3102 - EXTEL Price Validation Purge                         */
 
             CALL       SE3102
 
/*   If no database or file controls error is detected, the             +
      existing new EXTEL price validation files are restored            +
      to the EXTEL price validation files.                              */
 
        IF   COND(%SWITCH(XXXXXXX0))   THEN(DO)
             CPYF       FROMFILE(NEXVALD) TOFILE(EXVALD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CPYF       FROMFILE(NEXVALZ) TOFILE(EXVALZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
        ENDDO
 
/*   If U7 or U8 on process error                                       */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ERROR)
 
     ENDDO                                                   /*  E1  */
 
/*----------------------------------------------------------------------*/
 
 
/*   Change status in Data Area EXSTAT & end program                    */
 
     CHGDTAARA  DTAARA(EXSTAT (76 1)) VALUE(F)
     CHGDTAARA  DTAARA(EXSTAT (77 1)) VALUE(N)
     CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(N)
     CHGDTAARA  DTAARA(EXSTAT (108 30)) VALUE('EXTEL UPDATES +
                          COMPLETE')
 
 
/*   Update EXSTAT with incremented date (disregarding holidays         +
                                            in local currency)          +
     and Update EXSTAT with incremented sequence number                 */
 
/****OVRDBF     TABLE   TABSDU                                       * *S01117*/
     CALL       SE3115
/****DLTOVR     TABLE                                                * *S01117*/
 
     GOTO       ENDPGM
 
 
/*----------------------------------------------------------------------*/
 
/*   Perform ERROR PROCESS                                              */
 
 
/*   Set error flag                                                     */
 
 ERROR:      CHGDTAARA  DTAARA(EXSTAT (77 1))  VALUE(Y)
             CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(N)
 
     IF      COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
     ENDDO
 
 
     IF      COND(%SWITCH(XXXXXX01)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (168 8)) RTNVAR(&MIM)             * *S01117*/
             RTVDTAARA  DTAARA(LDA (171 10)) RTNVAR(&MIM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MIM) +
                    TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
     ENDDO
 
     SNDPGMMSG  MSG('SEC3104 - EXTEL Daily Changes Update +
            Ended Abnormally') TOMSGQ(MOPERQ)
 
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
