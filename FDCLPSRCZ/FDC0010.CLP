/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD Cntrlng component for SD Input')             */
/********************************************************************/
/*                                                                  */
/*       Midas     - Standing Data Module                       */
/*                                                                  */
/*       FDC0010 -  TABLE FILE MAINTENANCE  (BASED ON SDC03)        */
/*                                                                  */
/*       Function: This program is called from the SPF menu to      */
/*       (I/C)     control further program calls.                   */
/*                                                                  */
/*       Called by: Main menu                                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 110242             Date 07Nov96              */
/*                      089626             Date 28Jul95              */
/*                      S01319             Date 30OCT91              */
/*                      S01319             Date 24SEP91              */
/*                      S01328             Date 08FEB91              */
/*                      S01179             Date 21/10/88             */
/*                      E13404             Date 25/05/88             */
/*                      E12574             Date 10/03/88             */
/*                      S01136             Date 13/01/88             */
/*                                                                   */
/*********************************************************************/
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD      */
/*       089626 - Allow Interest Rates Maintenance also if Dealing  */
/*                is on FX/MM                                       */
/*       S01319 - (HY0003) Interest rates maintenance only allowed  */
/*                if TM or FRA/IRS is on.                           */
/*       S01319 - Remove redundant processing                       */
/*       S01328 - FRA/IRS Revaluation - Call Discount Factors       */
/*                Rebuild program (DLC1960) if MM Interest Rates    */
/*                have been amended.                                */
/*       S01179 - AS/400 CONVERSION                                 */
/*       E13404 - OVRDBF OF TABLE FILES FOR FD0100 MUST SPECIFY     */
/*                SHARE(*NO) TO AVOID INCONSISTENT COMMIT ERROR     */
/*       E12574 - PROGRAM RECOMPILED DUE TO MMOD CHANGED LENGTH     */
/*                TO 256 FOR MRPLIB22                               */
/*       S01136 - REDUNDANT LINES OF CODE (38 - 63) DELETED         */
/*                HEADER BOX ALTERED TO NAME PROGRAM FDC0010.       */
/********************************************************************/
             PGM        PARM(&PRM01)
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        &SWS          TYPE(*CHAR)  LEN(8)
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
             DCL        VAR(&RADA) TYPE(*DEC) LEN(5)                  /*S01328*/
             DCL        VAR(&DLMMDF) TYPE(*CHAR) LEN(16)              /*S01328*/
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)                /*S01319*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST') /*S01319*/
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(128)             /*S01319*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*           DCLDTAARA  DTAARA(MMOD)  */   /*S01179*/
/**/
               CHGJOB     SWS(00000000)
/**IF*(&PRM01**EQ 'FD0100') DO                                       /*S01319*/
/**OVRDBF TABLE FDTBRNLL                                           *  *E13404 */
/**OVRDBF TABLEI FDTBRNLL                                          *  *E13404 */
/**OVRDBF*FILE(TABLE) TOFILE(FDTBRNLL) SHARE(*NO)         /*E13404*/ /*S01319*/
/**OVRDBF*FILE(TABLEI) TOFILE(FDTBRNLL) SHARE(*NO)        /*E13404*/ /*S01319*/
/**ENDDO                                                             /*S01319*/
/**/
/************IF         COND(&PRM01 *EQ 'SD0010') THEN(DO)           */
/************  OVRDBF     FILE(CLIND) TOFILE(CLINT) SHARE(*NO)       */
/************  OVRDBF     FILE(CLINT2) TOFILE(CLINT) SHARE(*NO)      */
/************  RCVDTAARA  DTAARA(MMOD)                               */
/************  IF         COND(%SUBSTRING(&MMOD 10 1) *EQ Y) THEN(DO)*/
/************      CHGJOB     SWS(XX1XXXXX)                          */
/************  ENDDO                                                 */
/************  IF         COND(%SUBSTRING(&MMOD 02 1) *EQ Y) THEN(DO)*/
/************      CHGJOB     SWS(1XXXXXXX)                          */
/************  ENDDO                                                 */
/************  IF         COND(%SUBSTRING(&MMOD 04 1) *EQ Y) THEN(DO)*/
/************      CHGJOB     SWS(X1XXXXXX)                          */
/************  ENDDO                                                 */
/************ENDDO                                                   */
/**/
/************IF         COND(&PRM01 *EQ 'SD0180') THEN(DO)           */
/************   RCVDTAARA  DTAARA(MMOD)                              */
/************   IF         COND(%SUBSTRING(&MMOD 05 1) *EQ Y) THEN(DO*/
/************      CHGJOB     SWS(1XXXXXXX)                          */
/************   ENDDO                                                */
/************ENDDO                                                   */
/************IF         COND(&PRM01 *EQ 'SD0284') THEN(DO)           */
/************  OVRDBF     FILE(TABLE) TOFILE(TABSDM) SHARE(*NO)      */
/************  OVRDBF     FILE(TABLE2) TOFILE(TABSDM) SHARE(*NO)     */
/************ENDDO                                                   */
 /**/                                                                 /*S01328*/
 /* If MM Interest Rates program about to be called then add 1 to     /*S01328*/
 /* RADA (MM Interest Rates and Discount Factors Rebuild Active) on   /*S01328*/
 /* DLMMDF.  When the Discount Factors Rebuild completes successfully /*S01328*/
 /* this field will be decremented by 1, in program DLC1960.          /*S01328*/
             IF         COND(&PRM01 = 'FD0550') THEN(DO)              /*S01328*/
/* */                                                                 /*S01319*/
/***********AOMMODR0 to check if TM or FRA/IRS is on. If neith/*S01319/*089626*/
/* Call PGM/AOMMODR0 to check if TM or FRA/IRS or Dealing is on. If no/*089626*/
/* then send message that the option is not allowed and skip          /*S01319*/
/* processing.  */                                                    /*S01319*/
             CALL       PGM(AOMMODR0) PARM(&RTNCD &OPTN &SDMMOD)      /*S01319*/
/*****************IF       COND(%SST(&SDMMOD 47 1) *NE 'Y' *AND +
/*****************        %SST(&SDMMOD 50 1) *NE 'Y') THEN(DO)  S01319/*089626*/
/*****************SNDPGMMSG  MSG('This option is only allowed if +
/*****************     Treasury Management or FRA/IRS is on.') +
/*****************            TOPGMQ(*EXT)                      S01319/*089626*/
       IF  COND(%SST(&SDMMOD 23 1) *NE 'Y' *AND (%SST(&SDMMOD 47 1) +
           *NE 'Y') *AND (%SST(&SDMMOD 50 1) *NE 'Y')) THEN(DO)       /*089626*/
                  SNDPGMMSG  MSG('This option is only allowed if +
                       Treasury Management or FRA/IRS is on.') +
                              TOPGMQ(*EXT)                            /*089626*/
                  GOTO       CMDLBL(ENDCLPGM)                         /*S01319*/
                  ENDDO                                               /*S01319*/
/* */                                                                 /*S01319*/
               ALCOBJ     OBJ((DLMMDF *DTAARA *EXCL)) WAIT(30)        /*S01328*/
               RTVDTAARA  DTAARA(DLMMDF) RTNVAR(&DLMMDF)              /*S01328*/
               CHGVAR     VAR(&RADA) VALUE(%SST(&DLMMDF 1 5))         /*S01328*/
               CHGVAR     VAR(&RADA) VALUE(&RADA + 1)                 /*S03128*/
               CHGVAR     VAR(%SST(&DLMMDF 1 5)) VALUE(&RADA)         /*S01328*/
               CHGDTAARA  DTAARA(DLMMDF) VALUE(&DLMMDF)               /*S03128*/
               DLCOBJ     OBJ((DLMMDF *DTAARA *EXCL))                 /*S01328*/
             ENDDO                                                    /*S01328*/
 /**/                                                                 /*S01328*/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
 /**/                                                                 /*S01328*/
             CALL       PGM(&PRM01)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                ROLLBACK
                GOTO ENDCLPGM
             ENDDO
             RTVJOBA    SWS(&SWS)
/*                                                                  */
             IF         COND((&PRM01 *NE 'SD0280') *AND (&PRM01 *NE +
                          'SD0011')) THEN(DO)
 /*                                                                 */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job Terminated - Database +
                          Error')
             SNDMSG     MSG(&MSG) TOMSGQ(&JOB)
             ROLLBACK
 ENDD005:    ENDDO
 /* else no errors so, if MM Interest Rates program exited, */        /*S01328*/
 /* submit job to recalculate MM Discount Factors */                  /*S01328*/
             ELSE       CMD(IF COND(&PRM01 = 'FD0550') THEN(DO))      /*S01328*/
               SNDPGMMSG MSG('MIDAS') TOMSGQ(MSTATUS)                 /*S01328*/
/************* SBMJOB     JOB(DLC1960) JOBD(MBATCH) USER(*JOBD) +     /*110242*/
/*************            RQSDTA('CALL DLC1960') INLLIBL(*JOBD) +     /*110242*/
/*************            MSGQ(MOPERQ) */                     /*S01328  110242*/
/************  SBMJOB     JOB(DLC1960) JOBD(MBATCH) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL DLC1960') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*110242*/          /*CSC023*/
               SBMJOB     JOB(DLC1960) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL DLC1960') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/************  SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*S01328*/          /*CSC023*/
               SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             ENDDO
          ENDDO
          ELSE       CMD(DO)
 /*                                                                 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job Terminated - Database +
                          Error')
             SNDMSG     MSG(&MSG) TOMSGQ(&JOB)
             ROLLBACK
             ENDDO
          ENDDO
 /*                                                                 */
/**IF*(&PRM01**EQ 'FD0100') DO                                        /*S01319*/
/**DLTOVR*****FILE(TABLE TABLEI)                                      /*S01319*/
/**ENDDO                                                              /*S01319*/
 ENDCLPGM:   RETURN
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM    /* END CL PGM */
