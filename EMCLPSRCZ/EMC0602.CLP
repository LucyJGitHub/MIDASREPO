/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EM Create end of day exposure file')            */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                       */
/*                                                                  */
/*       EMC0602 - CREATE END OF DAY EXPOSURE FILE                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD030956           Date 09Oct14             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No.   CCB016         Date   03Aug07             */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                        CCB009         Date   01Jun00             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                        CTI002         Date   29Sep98             */
/*                        S01332         Date   24Apr91             *  *S01129*/
/*                        E21893         DATE   07AUG90             *  *S01129*/
/*                        S01155         DATE   14/04/88            *  *S01129*/
/*                        S01129         DATE   16/02/88            *  *S01129*/
/*                        E11699         DATE   10/11/87            */
/*                        E10841         DATE   04/08/87            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*           MD030956 - Additional changes to BFM-TI enhancement    */
/*           CCB016  -  CoB performance enhancement                 */
/*           CCB009  -  Journal files throughout close of business  */
/*           CTI002  -  TRADE INNOVATION PHASE 2                    */
/*           S01332  -  EXPOSURE MANAGEMENT RELEASE 10 ENHANCEMENTS.*/
/*           E21893  -  INCORRECT ALLOCATION OF ACCNT LOCKS OUT     */
/*                      OTHER COB STREAMS UNNECCESSARILY.           */
/*           S01155  -  SE INCORPORATION ERROR FIX - EM0660 BEING   *  *S01155*/
/*                      CALLED UNCONDITIONALLY                      *  *S01155*/
/*           S01129  -  SECURITIES TRADING II INCORPORATION         *  *S01129*/
/*           E11699  -  ACCNT SHOULD BE ALLOCATED BEFORE USE.       *  *E11699*/
/*           E10841  -  OVERRIDE ON FILE CLINTC TO FILE CLINT       */
/*                                                                  */
/********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*/COPY WNCPYSRC,EMC0602001                                          */
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('Exposure Management Create End +
                               Of Day Exposure File')
 
/* CTI002 Start */
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*CTI002*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CTI002*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CTI002')                             /*CTI002*/
             DCL        VAR(&EMUSRMSG) TYPE(*CHAR) LEN(10)            /*CTI002*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*CTI002*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*CTI002*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*CTI002*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*CTI002*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*CTI002*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*CTI002*/
             DCL        VAR(&CB) TYPE(*CHAR) LEN(2)                   /*CTI002*/
             DCL        VAR(&SA) TYPE(*CHAR) LEN(2)                   /*CTI002*/
             DCL        VAR(&SL) TYPE(*CHAR) LEN(2)                   /*CTI002*/
             DCL        VAR(&XRTCD) TYPE(*CHAR) LEN(7)                                  /*MD030956*/
             DCL        VAR(&XSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CTI007')                                               /*MD030956*/
/* CTI002 End   */
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
                        SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/
                RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/                                                                  /*CTI002*/
/* MULTILANGAGE SUPPORT    */                                         /*CTI002*/
/**/                                                                  /*CTI002*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*CTI002*/
 
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*CTI002*/
             CHGVAR     VAR(&MULT) VALUE('GB')                        /*CTI002*/
             ENDDO                                                    /*CTI002*/
             CHGVAR     VAR(&EMUSRMSG) VALUE(&MULT *CAT 'EMUSRMSG  ') /*CTI002*/
             OVRMSGF    MSGF(EMUSRMSG) TOMSGF(&EMUSRMSG)              /*CTI002*/
                CLRPFM     FILE(EMDEXX4)       /* CLEAR EMDEX FILES */
                CLRPFM     FILE(EMDEXX5)
                CLRPFM     FILE(EMDEXX6)
/**/
                CLRPFM     FILE(EMCEXX1)       /* CLEAR EMCEX FILES */
                CLRPFM     FILE(EMCEXX2)
                CLRPFM     FILE(EMCEXX3)
/**/                                                                  /*S01129*/
                CLRPFM     FILE(EMXT6T1)                              /*S01129*/
                CLRPFM     FILE(EMXT6D1)                              /*S01129*/
                CLRPFM     FILE(EMTFEXPD)                             /*CTI002*/
/*/COPY WNCPYSRC,EMC0602004                                          */
             IF         COND(%SST(&MMOD 21 1) *EQ 'Y') THEN(DO)       /*S01155*/
             OVRDBF     FILE(CLINTC) TOFILE(CLINT) SHARE(*NO)         /*S01129*/
/**/                                                                  /*S01129*/
                CALL    PGM(EM0660)                                   /*S01129*/
             ENDDO                                                    /*S01155*/
/*/COPY WNCPYSRC,EMC0602002                                          */
                IF      COND(%SWITCH(XXXXXX0X)) THEN(DO)              /*S01129*/
/**/
/*/COPY WNCPYSRC,EMC0602003                                          */
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
/*           OVRDBF     FILE(CLINTC) TOFILE(CLINT)    */  /* E10841 */
/*           OVRDBF     FILE(CLINTC) TOFILE(CLINT) SHARE(*NO)       *  *S01129*/
/**/                                                                  /*S01332*/
             OVRDBF     FILE(EMDEX) TOFILE(EMDEX) SHARE(*NO)          /*S01332*/
/**/                                                                  /*S01332*/
/************ALCOBJ*****OBJ((ACCNT *FILE *EXCLRD)) WAIT(9999)  /*E11699*E21893*/
             ALCOBJ     OBJ((ACCNT *FILE *SHRRD)) WAIT(1800)          /*E21893*/
 
             OVRDBF     FILE(EMDEXX4) NBRRCDS(500) SEQONLY(*YES 500)                      /*CCB016*/
             OVRDBF     FILE(EMDEXX5) NBRRCDS(500) SEQONLY(*YES 500)                      /*CCB016*/
             OVRDBF     FILE(EMDEXX6) NBRRCDS(500) SEQONLY(*YES 500)                      /*CCB016*/
 
             CALL       PGM(EM0450)
             DLTOVR     FILE(EMDEXX4)                                                     /*CCB016*/
             DLTOVR     FILE(EMDEXX5)                                                     /*CCB016*/
             DLTOVR     FILE(EMDEXX6)                                                     /*CCB016*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDP)       /*CTI002*/
 
                                                                      /*CTI002*/
/* CTI002 Start */                                                    /*CTI002*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*CTI002*/
             CALL       PGM(AOSARDR0) PARM(&XRTCD &SOPTN &XSARD)                        /*MD030956*/
/**/                                                                  /*CTI002*/
/* ERROR */                                                           /*CTI002*/
/**/                                                                  /*CTI002*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ' *OR &XRTCD *NE '         '    +
                           *AND &XRTCD *NE '*NRF   ') THEN(DO)                          /*MD030956*/
/**********               '*NRF   ') THEN(DO)                                    /*CTI002 MD030956*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*CTI002*/
             CHGJOB (XXXXXX11)                                        /*CTI002*/
             ENDDO                                                    /*CTI002*/
                                                                      /*CTI002*/
/**/                                                                  /*CTI002*/
/* Switchable Feature installed    */                                 /*CTI002*/
/**/                                                                  /*CTI002*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)                      /*CTI002 MD030956*/
             IF         COND(&SRTCD *EQ '       ' *OR &XRTCD *EQ  +
                             '       ') THEN(DO)                                        /*MD030956*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(EMTFCBPD) JRN(CBJRN)                     /*CTI002*/
             MONMSG   MSGID(CPF7030) EXEC(CHGVAR VAR(&CB) VALUE('Y')) /*CTI002*/
             STRJRNPF   FILE(EMTFSAPD) JRN(CBJRN)                     /*CTI002*/
             MONMSG   MSGID(CPF7030) EXEC(CHGVAR VAR(&SA) VALUE('Y')) /*CTI002*/
             STRJRNPF   FILE(EMTFSLPD) JRN(CBJRN)                     /*CTI002*/
             MONMSG   MSGID(CPF7030) EXEC(CHGVAR VAR(&SL) VALUE('Y')) /*CTI002*/
             ENDDO                                                    /*CCB009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CTI002*/
             MONMSG     MSGID(CPF8351)                                /*CTI002*/
             CALL       PGM(EM0452)                                   /*CTI002*/
             ENDCMTCTL                                                /*CTI002*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             IF       COND(&CB *NE 'Y') THEN(ENDJRNPF FILE(EMTFCBPD)) /*CTI002*/
             IF       COND(&SA *NE 'Y') THEN(ENDJRNPF FILE(EMTFSAPD)) /*CTI002*/
             IF       COND(&SL *NE 'Y') THEN(ENDJRNPF FILE(EMTFSLPD)) /*CTI002*/
             ENDDO                                                    /*CCB009*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDP)       /*CTI002*/
/**/
             OVRDBF     FILE(EMTRCKPD) TOFILE(EMTRCKPD) SECURE(*YES) +
                          SHARE(*YES)                                 /*CTI002*/
             OPNQRYF    FILE((EMTRCKPD)) KEYFLD((PGMN) (MSGID))       /*CTI002*/
             CALL       PGM(EM0720)                                   /*CTI002*/
             CLOF EMTRCKPD                                            /*CTI002*/
             DLTOVR FILE(EMTRCKPD)                                    /*CTI002*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDP)       /*CTI002*/
             CLRPFM     FILE(EMTRCKPD)                                /*CTI002*/
/**/
             ENDDO                                                    /*CTI002*/
/* CTI002 End   */                                                    /*CTI002*/
             DLCOBJ     OBJ((ACCNT *FILE *SHRRD))                     /*E21893*/
/************DLCOBJ*****OBJ((ACCNT *FILE *EXCLRD))             /*E11699*E21893*/
/**/                                                                  /*S01129*/
             ENDDO                                                    /*S01129*/
/**/                                                                  /*S01129*/
 ENDP:                                                                /*CTI002*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
