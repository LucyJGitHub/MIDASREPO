/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Daily Changes Wire Take-On')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3111  -  EXTEL DAILY CHANGES WIRE TAKE ON               */
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
/*       Prev Amend No. S01117             Date 11Jan91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
      DCL    &COUNT       *DEC       1 0       /* No of retries count         */
      DCL    &COUNTA      *CHAR      1         /* Count (alpha)               */
      DCL    &EXTRAN      *DEC       1 0       /* No allowable trans.         */
      DCL    &EXTRANA     *CHAR      1         /* No allow.trans(alpha)       */
      DCL    &DATE        *CHAR      6         /* System date                 */
      DCL    &EXST        *CHAR      1         /* Extel status                */
      DCL    &INFO        *CHAR     61         /* *CAT of next 3              */
      DCL    &EXEF        *CHAR      1         /* Extel error flag            */
      DCL    &STNR        *CHAR     30         /* Status narr                 */
      DCL    &TRSN        *CHAR     30         /* Termination reason          */
      DCL    &JINFO       *CHAR     26         /* *CAT of next 3              */
      DCL    &JOB         *CHAR     10         /* Job name                    */
      DCL    &USER        *CHAR     10         /* Job user                    */
      DCL    &NBR         *CHAR      6         /* Job number                  */
/*****DCL    &DATA        *CHAR     44         /* LDA data           * *S01117*/
      DCL    &DATA        *CHAR     50         /* LDA data            /*S01117*/
      DCL    VAR(&RSEQ) TYPE(*CHAR) LEN(5)                            /*S01117*/
 
 
        SNDUSRMSG  MSG('EXTEL Daily Changes Wire Reception') +
                          MSGTYPE(*INFO)  TOMSGQ(MOPERQ)
 
/*  Set count                                                          */
 
        CHGVAR     &COUNT (1)
 
/*  Reset error flag & termination reason                              */
 
         CHGDTAARA  DTAARA(EXSTAT (77 1))  VALUE('N')
         CHGVAR     &TRSN ('                              ')
         CHGDTAARA  DTAARA(EXSTAT (78 30))  VALUE(&TRSN)
 
/*  Retreive Job Name,Number,User,Date & Time and place in EXSTAT       */
 
        RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
        CHGVAR     &JINFO (&JOB *CAT &USER *CAT &NBR)
        CHGDTAARA  DTAARA(EXSTAT (38 26))  VALUE(&JINFO)
 
/*  Clear the EXTEL Link error file                                    */
 
        CLRPFM     EXLNKD
 
/*  Find maximum number of retries allowed from EXSTAT                 */
 
        RTVDTAARA  DTAARA(EXSTAT (144 1)) RTNVAR(&EXTRANA)
        CHGVAR     VAR(&EXTRANA) VALUE(&EXTRAN)
 
/*---------------------------------------------------------------------*/
 
/*  Check the Line, Device & Control unit                              */
 
/*******CALL*******SEC3111A                                          * *S01117*/
        CALL       PGM(SEC3111A) PARM(&RSEQ)                          /*S01117*/
 
/*  If error on Device Check skip to end                               */
 
        RTVDTAARA  DTAARA(EXSTAT (77 1)) RTNVAR(&EXEF)
 
        IF         COND(&EXEF *EQ 'Y')   THEN(GOTO ENDPGM)
 
/*---------------------------------------------------------------------*/
 
/*  If reception error loop back to here                               */
 
 RETRY: CHGJOB     SWS(00000000)                           /***   RETRY    ***/
 
        CLRPFM     EXWIRD
 
/*  Set EXTEL status & status narrative                                */
 
        CHGVAR     &EXST ('T')
        CHGVAR     &STNR ('WIRE RECEPTION   SEC3111      ')
 
        CHGDTAARA  DTAARA(EXSTAT (76 1))  VALUE(&EXST)
        CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
/*  Call the Wire reception program                                    */
 
        CALL       SE3110
 
/*---------------------------------------------------------------------*/
 
/*  Update EXSTAT & access LDA if database error                        */
 
              IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &TRSN ('DATABASE ERROR IN SE3110      ')
                 CHGVAR     &STNR ('DATABASE ERROR IN SE3110      ')
 
                 CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                 CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
/****************RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)     * *S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)      /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                 GOTO REPORT
 
              ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  Update EXSTAT if reception error                                    */
 
     IF   COND(%SWITCH(XXXXX100))   THEN(DO)
 
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &TRSN ('RECEPTION ERROR IN SE3110     ')
                 CHGVAR     &STNR ('RECEPTION ERROR IN SE3110     ')
 
                 CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                 CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
                 SNDUSRMSG  MSG('EXTEL Reception Error') +
                             MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
/*  Process depending on number of retries allowed                      */
 
            IF       COND(&COUNT *LE &EXTRAN) THEN(DO)
 
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &COUNTA &COUNT
                 CHGVAR     &STNR ('EXTEL RECEPTION RESTART NO' *BCAT &COUNTA)
 
                 CHGDTAARA  DTAARA(EXSTAT (77 1))    VALUE(&EXEF)
                 CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
                 CHGDTAARA  DTAARA(EXSTAT (145 1))   VALUE(&COUNT)
 
                 SNDUSRMSG  MSG(&STNR) MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
                 CHGVAR   &COUNT (&COUNT + 1)
 
/*---------------------------------------------------------------------*/
 
                 GOTO  RETRY
 
/*---------------------------------------------------------------------*/
 
                 ENDDO
 
            ELSE DO
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &TRSN ('NO SUCCESSFUL TRANSMISSION    ')
                 CHGVAR     &STNR ('NO SUCCESSFUL TRANSMISSION    ')
 
                 CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                 CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
                 GOTO  REPORT
 
                 ENDDO
 
            ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  Wire reformat processing                                           */
 
                 CHGVAR     &STNR ('SE3111 WIRE REFORMAT          ')
                 CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
                 SNDUSRMSG  MSG('EXTEL Daily Changes Wire Reformat') +
                               MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
/*---------------------------------------------------------------------*/
 
/*  Call the Wire reformat program                                     */
 
                 CALL  SE3111
 
/*  Update EXSTAT & access LDA if database error                        */
 
                IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 
                   CHGVAR     &EXEF ('Y')
                   CHGVAR     &TRSN ('DATABASE ERROR IN SE3111      ')
                   CHGVAR     &STNR ('DATABASE ERROR IN SE3111      ')
 
                   CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                   CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
                   RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)
/******************RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)   * *S01117*/
                   RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)    /*S01117*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                   GOTO  REPORT
 
                ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  Update EXSTAT if file out of balance                                */
 
                IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
 
                   CHGVAR     &EXEF ('Y')
                   CHGVAR     &TRSN ('FILE OUT OF BALANCE SE3111    ')
                   CHGVAR     &STNR ('FILE OUT OF BALANCE SE3111    ')
 
                   CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                   CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
                   SNDUSRMSG  MSG('File Controls out of Balance') +
                                 MSGTYPE(*INFO)  TOMSGQ(MOPERQ)
 
                   GOTO  REPORT
 
                ENDDO
 
/*---------------------------------------------------------------------*/
 
/*  If transmission ended normally update EXTEL status data area       */
 
        RTVJOBA    DATE(&DATE)
        CHGDTAARA  DTAARA(EXSTAT (64 6))  VALUE(&DATE)
 
        CHGVAR     &EXST ('C')
        CHGVAR     &EXEF ('N')
        CHGVAR     &TRSN ('                              ')
        CHGVAR     &STNR ('TRANS. COMPLETED NORMALLY     ')
 
        CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
        CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
        CHGDTAARA  DTAARA(EXSTAT (76 1))   VALUE(&EXST)
 
/*---------------------------------------------------------------------*/
 
/*  Produce Link report                                                */
 
/*REPORT:**CALL******SEC3113                     /***   REPORT   ***/ /*S01117*/
REPORT:   CALL  PGM(SEC3113) PARM(&RSEQ)         /***   REPORT   ***/ /*S01117*/
 
/*---------------------------------------------------------------------*/
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
