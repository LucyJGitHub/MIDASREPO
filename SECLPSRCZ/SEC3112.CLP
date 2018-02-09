/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE EXTEL Daily Changes Tape Take-On')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*      SEC3112  -  EXTEL DAILY CHANGES TAPE TAKE ON                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 11Jan91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)         */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
      DCL        &TDEV       *CHAR     10       /* Tape device                */
      DCL        &TDVIND     *CHAR      1       /* Tape device ind            */
      DCL        &DATE       *CHAR      6       /* System date                */
      DCL        &EXST       *CHAR      1       /* Extel status               */
      DCL        &INFO       *CHAR     61       /* *CAT of next 3             */
      DCL        &EXEF       *CHAR      1       /* Extel error flag           */
      DCL        &STNR       *CHAR     30       /* Status narr                */
      DCL        &TRSN       *CHAR     30       /* Termination reason         */
      DCL        &RMSG       *CHAR    132       /* Reply message              */
/*****DCL        &DATA       *CHAR     44       /* LDA data          * *S01117*/
      DCL        &DATA       *CHAR     50       /* LDA data           /*S01117*/
 
 
        SNDUSRMSG  MSG('EXTEL Daily Changes Tape Reception') +
                          MSGTYPE(*INFO) TOMSGQ(MOPERQ)
        CHGJOB     SWS(XXXXX000)
 
/*---------------------------------------------------------------------*/
 
/*  Find name of tape device                                           */
 
        RTVDTAARA  DTAARA(EXSTAT (11 10))   RTNVAR(&TDEV)
 
/*  Check if tape device is valid                                      */
 
CHKTAP:  CALL    SEC3112A   PARM(&TDEV &TDVIND)          /*** CHKTAP ***/
 
         CLRPFM  EXTAPD
 
/*---------------------------------------------------------------------*/
 
/*  If error send msg to user                                          */
 
        IF    COND(&TDVIND *NE ' ') THEN(DO)
 
              CHGVAR     &TDVIND (' ')
              CHGVAR     &EXEF ('Y')
              CHGVAR     &TRSN ('TAPE ERROR                    ')
              CHGVAR     &STNR ('TAPE ERROR                    ')
              CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
              CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
              SNDUSRMSG  MSG('Tape Device Error. Enter R to retry, E +
                          to end program') VALUES(R E) DFT(E) +
                          TOMSGQ(*EXT) MSGRPY(&RMSG)
 
/*  If yes retry, if no end                                            */
 
              IF    COND(&RMSG *EQ 'R')      THEN(GOTO CHKTAP)
              ELSE  IF   COND(&RMSG *EQ 'E') THEN(GOTO ENDPGM)
 
              ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  Tape reformat processing                                           */
 
         CHGVAR     &EXST ('T')
         CHGVAR     &STNR ('TAPE UNLOAD                   ')
 
         CHGDTAARA  DTAARA(EXSTAT (76 1))   VALUE(&EXST)
         CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
         SNDUSRMSG  MSG('EXTEL Daily Changes Tape Reformat') +
                          MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
/*  Unload tape                                                        */
 
             DLTF       FILE(QTEMP/EXTAPFIL)
         MONMSG     MSGID(CPF2105)
 
         CRTTAPF    FILE(QTEMP/EXTAPFIL) DEV(&TDEV) REELS(*NL) +
                          BLKLEN(1300) RCDBLKFMT(*U)
         CPYF       FROMFILE(EXTAPFIL) TOFILE(EXTAPD) +
                      MBROPT(*REPLACE) FMTOPT(*NOCHK)
 
         DLTF       FILE(QTEMP/EXTAPFIL)
         MONMSG     MSGID(CPF2105)
 
         CHGVAR     &STNR ('TAPE REFORMAT SE3112          ')
         CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
/*---------------------------------------------------------------------*/
 
/*  Call tape reformat program                                         */
 
         CALL SE3112
 
/*---------------------------------------------------------------------*/
 
/*  Update EXSTAT & access LDA if database error                        */
 
              IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &TRSN ('TAPE FORMAT ERROR IN SE3112   ')
                 CHGVAR     &STNR ('TAPE FORMAT ERROR IN SE3112   ')
 
                 CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                 CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
/****************RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)     * *S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)      /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                 GOTO  ENDPGM
 
              ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  Update EXSTAT if file out of balance                                */
 
                IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
 
                   CHGVAR     &EXEF ('Y')
                   CHGVAR     &TRSN ('FILE OUT OF BALANCE SE3112    ')
                   CHGVAR     &STNR ('FILE OUT OF BALANCE SE3112    ')
 
                   CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                   CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
                   SNDUSRMSG  MSG('File Controls out of Balance in +
                          SEC3112') MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
                   GOTO  ENDPGM
 
                ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  If ended normally update EXTEL status data area                    */
 
        RTVJOBA    DATE(&DATE)
        CHGDTAARA  DTAARA(EXSTAT (64 6))  VALUE(&DATE)
 
        CHGVAR     &EXST ('C')
        CHGDTAARA  DTAARA(EXSTAT (76 1))  VALUE(&EXST)
 
        CHGVAR     &EXEF ('N')
        CHGVAR     &TRSN ('                              ')
        CHGVAR     &STNR ('TAPE COMPLETED NORMALLY       ')
 
        CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
        CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
/*---------------------------------------------------------------------*/
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
