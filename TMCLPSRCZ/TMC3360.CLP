/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Upd Forw. Bk fls for FRA,IRS,LE,FF trade')      */
/********************************************************************/
/*                                                                  */
/*       Midas     - Treasury management module.                */
/*                                                                  */
/*       TMC3360 - INCLUDE DATA FROM FRA, IRS, FF, LE INTO THE      */
/*                 MM FORWARD BOOK FILES.                           */
/*                                                                  */
/*       Function: This program controls the process by which trades*/
/*       (I/C)     from FRA, IRS, FF and LE are included in the MM  */
/*       (COB)     forward book file. It is called automatically    */
/*                 during I/C initiation and can also be requested  */
/*                 at any time during I/C from SPF menu.            */
/*                                                                  */
/*       Called by: SPF  menu (I/C)                                 */
/*                  MM8010/MM0101 (COB)                             */
/*                                                                  */
/*       Calls    : TM3340  - Takeon FRA, IRS, Futures into fwd book*/
/*                  LE0480  - Create loan events extract file       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX            DATE XX/XXX/XX            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CREATED FOR S01280 - INCLUDE LE, FRA, IRS, FF INTO         */
/*       15OCT90              MM FORWARD BOOK FILE                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
          PGM PARM(&TERM)
 
             DCL        VAR(&LEFLAG) TYPE(*CHAR) LEN(1) /* LE on +
                          system? */
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)            /* +
                          Error parm for RPG pgm */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) /* Msg data +
                          for error message */
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10) /* Job name */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8) /* Job switches */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(DLMMTOLL) /* Takeon in progress flags */
 
/*  Global monitor message                                           */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ENDPGM)
 
 
/* Reset job switches (with EM off for this processing)             */
 
          CHGJOB SWS(0XXXX000)
 
/* If takeon is already in progress then skip processing            */
             RCVF
 
/* If rcd not found, must be first run after installation, DL3340 */
/* will write a record, so no worries here                        */
             MONMSG CPF0864   /*End of file*/
             IF         COND(&TOTOIP *EQ 'Y') THEN(GOTO CMDLBL(ENDPGM))
 
/* If LE is on the system then generate LE events                    */
             RTVDTAARA  DTAARA(MMOD (10 1)) RTNVAR(&LEFLAG)
 
             IF         COND(&LEFLAG *EQ 'Y') THEN(DO)
 
/* Set takeon in progress flag to 'Y'                                */
             CALL PGM(TM3340) PARM('Y')
 
/* If DTAARA/LDA does not exit, create it for use by LE0480          */
 
                CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA  +
                             DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                            VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                             DATA AREA EQUIVALENT'))
 
/* Clear files.                                                      */
 
           CLRPFM     FILE(LVNTXHH)
           CLRPFM     FILE(LVNTXEL)
           CLRPFM     FILE(LVNTXZZ)
 
/* Overide files.                                              */
 
           OVRDBF     FILE(LVNTXEL) SEQONLY(*YES 100)
 
/* Generate LE events.                                               */
 
           CALL       LE0480
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                          (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
 
/* Process for database errors, set Takeon in Progress flag to 'N'    */
             CALL PGM(TM3340) PARM('N')
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO TAG01
 
             ENDDO
             ENDDO
 
/* Update the MM forward book with data from other modules           */
 
          CALL       PGM(TM3340) PARM(&TERM)
 
/* Error processing */
 
             IF         COND((%SWITCH(XXXXX1XX)) *OR +
                          (%SWITCH(XXXXXX11)) *OR (&TERM *NE +
                          ' ')) THEN(DO)
             RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MEM)
              SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
 
          ENDDO
 
/* Clear files filled by LE event generation                         */
 
TAG01:    CLRPFM     FILE(LVNTXHH)
          CLRPFM     FILE(LVNTXEL)
          CLRPFM     FILE(LVNTXZZ)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM:ENDPGM
