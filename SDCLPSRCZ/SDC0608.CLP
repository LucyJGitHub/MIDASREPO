/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check/Update Accrual date')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/*       SDC0608 - CHECK UPDATE/ACCRUAL DATES                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S10736             Date 11Nov92              */
/*                      S01333             Date 04Apr91              */
/*                      S01189                  DATE  06/04/89      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S10736 - MANAGEMENT ACCOUNTS                               */
/*       S01333 - MIS GL REAL TIME POSTING                          */
/*       S01189 - STANDARDISE DATABASE ERROR JOB SWITCH SETTINGS    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL           VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,SDC0608001                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*                                                                  */
             RTVJOBA       JOB(&JOB)
/**/
/*/COPY WNCPYSRC,SDC0608002                                          */
             OVRDBF        FILE(TABLE) TOFILE(TABSDU)
             OVRDBF        FILE(TABLEU) TOFILE(TABSDU) SHARE(*NO)
             CALL          PGM(SD0640)
             IF            COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGJOB        SWS(XXXXXX1X)                           /*S01189*/
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(&JOB) MSGTYPE(*INFO)
             ENDDO
/**/                                                                  /*S01333*/
/*****************************                                        /*S10736*/
/************ELSE*******(DO)**                                        /*S10736*/
/************CPYF*******FROMFILE(GLACBTPD) TOFILE(GLACBYPD) +         /*S10736*/
/*************************MBROPT(*REPLACE)                            /*S10736*/
/************MONMSG*****MSGID(CPF2817) CMPDTA(CPF2869)      +         /*S10736*/
/***********************EXEC(CLRPFM GLACBYPD)                         /*S10736*/
/************CPYF*******FROMFILE(ACCNTAB) TOFILE(GLACBTPD) +          /*S10736*/
/*************************MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*S10736*/
/************MONMSG*****MSGID(CPF2817) CMPDTA(CPF2869)     +          /*S10736*/
/***********************EXEC(CLRPFM GLACBTPD)                         /*S10736*/
/************ENDDO************                                        /*S10736*/
/**/                                                                  /*S01333*/
          ENDPGM
