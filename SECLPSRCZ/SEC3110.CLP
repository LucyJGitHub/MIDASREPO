/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL daily changes take-on')                */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                     */
/*                                                                   */
/*       SEC3110  -  EXTEL DAILY CHANGES TAKE ON CONTROL             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 10Jan91              */
/*                      E20718             Date 16Jan90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       S01117 - MULTIBRANCHING                                     */
/*       E20718 - ADD EXTRA PARMS, RTGDTA(*JOBD),                    */ /*E20718*/
/*                INLLIBL(*JOBD) TO SBMJOB COMMAND.                  */ /*E20718*/
/*       **** REQUIRED FOR AS400 ONLY, DEFAULTS OK FOR S/38 ****     */ /*E20718*/
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
      DCL    &TWIN     *CHAR      1          /* Tape/Wire Ind                 */
      DCL    &JINFO    *CHAR     26          /* *CAT of next 3                */
      DCL    &JOB      *CHAR     10          /* Job name                      */
      DCL    &USER     *CHAR     10          /* Job user                      */
      DCL    &NBR      *CHAR      6          /* Job number                    */
      DCL    &DATE     *CHAR      6          /* System date                   */
      DCL    &TIME     *CHAR      6          /* System time                   */
      DCL    &EXST     *CHAR      1          /* Extel status                  */
      DCL    &STNR     *CHAR     30          /* Status narrative              */
      DCL    &EXEF     *CHAR      1          /* Extel error flag              */
 
        SNDUSRMSG  MSG('EXTEL Daily Changes Take-On Control') +
                       MSGTYPE(*INFO)   TOMSGQ(MOPERQ)
 
 
/*  Set flag so maintenance program may not be run                     */
 
        CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(Y)
 
/*  Retrieve status and error flag                                     */
 
        RTVDTAARA  DTAARA(EXSTAT (76 1))     RTNVAR(&EXST)
        RTVDTAARA  DTAARA(EXSTAT (77 1))     RTNVAR(&EXEF)
        RTVDTAARA  DTAARA(EXSTAT (108 30))   RTNVAR(&STNR)
 
/*  Do not continue if there has been an error after the               +
      transmission has completed                                       */
 
        IF         COND(&EXEF *EQ 'Y')  THEN(DO)             /*  B1  */
          IF       COND((&EXST *NE 'A') *AND (&EXST *NE 'T')) +
                          THEN(DO)                           /*  B2  */
                   SNDPGMMSG  MSG('Transmission completed. Run +
                                   updates from the menu option') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO    ENDPGM
          ENDDO                                              /*  E2  */
        ENDDO                                                /*  E1  */
 
/*  Do not continue if the previous day's link processing              +
       has not finished                                                */
 
        IF         COND((&EXEF *EQ 'N') *AND (&EXST *NE 'F'))     +
                           THEN(DO)                          /*  B1  */
                   SNDPGMMSG  MSG(&STNR *BCAT 'NOT COMPLETED')    +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO    ENDPGM
        ENDDO                                                /*  E1  */
 
/*---------------------------------------------------------------------*/
 
/*  Set off switches                                                   */
 
        CHGJOB     SWS(00000000)
 
/*  Retreive Job Name,Number,User,Date & Time and place in EXSTAT       */
 
        RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR) DATE(&DATE)
        CHGDTAARA  DTAARA(EXSTAT (26 6))   VALUE(&DATE)
        CHGVAR     &JINFO (&JOB *CAT &USER *CAT &NBR)
        CHGDTAARA  DTAARA(EXSTAT (38 26))  VALUE(&JINFO)
        RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
        CHGDTAARA  DTAARA(EXSTAT (32 6))   VALUE(&TIME)
 
/*  Set off EXTEL error flag                                           */
 
        CHGDTAARA  DTAARA(EXSTAT (77 1))  VALUE('N')
 
/*  Set EXTEL status & status narrative                                */
 
        CHGDTAARA  DTAARA(EXSTAT (76 1))    VALUE('A')
        CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE('AWAITING DATA')
 
/*---------------------------------------------------------------------*/
 
/*  Clear EXTEL files                                                  */
 
        CLRPFM     EXTELA
        CLRPFM     EXTELF1
        CLRPFM     EXTELZ
 
        CLRPFM     EXTF4A
        CLRPFM     EXTF4B
        CLRPFM     EXTF4C
        CLRPFM     EXTF4D
        CLRPFM     EXTF4E
        CLRPFM     EXTF4F
        CLRPFM     EXTF4G
        CLRPFM     EXTF4H
        CLRPFM     EXTF4I
        CLRPFM     EXTF4J
        CLRPFM     EXTF4K
        CLRPFM     EXTF4L
 
/*---------------------------------------------------------------------*/
 
/*  Check whether data is from WIRE or TAPE                            */
 
        RTVDTAARA  DTAARA(EXSTAT (10 1))   RTNVAR(&TWIN)
 
/*  If data is from WIRE call SEC3111                                  +
    if data is from TAPE call SEC3112                                  */
 
/*******IF**       COND(&TWIN *EQ 'W') THEN(SBMJOB JOB(SEC3111)   +   /*E20718*/
/***********              JOBD(EXTELJOBD) JOBQ(EXTELJOBQ)         +   /*E20718*/
/***********              RQSDTA('CALL SEC3111') MSGQ(MOPERQ))        /*E20718*/
/************IF         COND(&TWIN *EQ 'W') THEN(SBMJOB JOB(SEC3111) +                    /*CPK014*/
/************             JOBD(EXTELJOBD) JOBQ(EXTELJOBQ) +                               /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SEC3111') +                          /*CPK014*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ))                                    /*CPK014*/
/************IF         COND(&TWIN *EQ 'W') THEN(SBMJOB JOB(SEC3111) +                    /*CSC023*/
/************             JOBD(EXTELJOBD) JOBQ(EXTELJOBQ) +                               /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             SEC3111') INLLIBL(*JOBD) MSGQ(MOPERQ))               /*CPK014*/ /*CSC023*/
             IF         COND(&TWIN *EQ 'W') THEN(SBMJOB JOB(SEC3111) +
                          JOBD(EXTELJOBD) JOBQ(EXTELJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          SEC3111') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD))              /*CSC023*/
/************                                                         /*E20718*/
        ELSE       IF     COND(&TWIN *EQ 'T') THEN(CALL SEC3112)
                   ELSE   DO
                          SNDPGMMSG  MSG('Tape/Wire indicator on Data +
                            Area EXSTAT is invalid') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                          ENDDO
 
/*---------------------------------------------------------------------*/
 
   ENDPGM:
 
/*  Reset flag                                                         */
 
             CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(Y)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
