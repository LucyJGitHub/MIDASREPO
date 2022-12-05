/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Run MMM Archiving')                                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - RZ Developments                                     */
/*                                                                   */
/*       RZC001125 - Run MPM Archiving                               */
/*                                                                   */
/*       Last Amend No. AR1084152A           Date 30May13            */
/*       Prev Amend No. AR1084152 *Create    Date 31Jan13            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1084152A - Use the correct MPM Archiving User for Test.   */
/*                    (Child: AR1084154)                             */
/*       AR1084152 - Automate MPM dbase and archiving during CoB     */
/*                 - (Child:AR1084154)                               */
/*                                                                   */
/*********************************************************************/
             Pgm

/* Define variables */

             Dcl        Var(&MPlusDbPfx) Type(*CHAR) Len(2)
             Dcl        Var(&MainMMMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&ArchMMMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&MplusDiLib) Type(*CHAR) Len(10)
             Dcl        Var(&Midasdate ) Type(*CHAR) Len(7)
             Dcl        Var(&MMMUser   ) Type(*CHAR) Len(10)                          /*AR1084152*/

             Dcl        Var(&Today     ) Type(*Dec ) Len(5 0)
             Dcl        Var(&Tomorrow  ) Type(*Dec ) Len(5 0)
             Dcl        Var(&DayDiff   ) Type(*Dec ) Len(5 0)
             DCL        VAR(&XXMIDAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SQLSTMNT) TYPE(*CHAR) LEN(40)                            /*AR1084152*/
             DCL        VAR(&HANDLE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ERRCODE) TYPE(*CHAR) LEN(8) VALUE(X'0000000000000000')

/* Global message monitor */
             Monmsg     MsgId(CPF0000 MCH0000) Exec(Goto CmdLbl(Error))

             Chgjob     Sws(xxxxxx00)

/* Save Archive only when a CoB with non-working day */
             Call       Pgm(RZ001450) Parm(&Today &Tomorrow)

             Chgvar     Var(&DayDiff) VALUE(&Tomorrow - &Today)

/*********  If         Cond(&DayDiff *Ne 1) Then(Do)   *********/


/* Retrieve System Prefix */

             RtvDtaara  Dtaara(SdStat (6 2)) RtnVar(&MPlusDbPfx)
             RtvDtaara  Dtaara(Rundat (1 7)) RtnVar(&MidasDate )

/* Call program to determine libraries to be backed up */

             Call       Pgm(RZ001120) Parm(&MPLusDbPfx &MainMMMDb &ArchMMMDb +
                          &MMMUser)                                                   /*AR1084152*/
/* Transfer job control to MPM archiving user xxMPMARC */
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPREFIX)                    */ /*AR1084152*/
/**Test*MPM archiving user */                                                         /*AR1084152*/
/**********  If         Cond(&SysPrefix = 'T8') Then(Do)                           */ /*AR1084152*/
/**********  CHGVAR     VAR(&XXMIDAS) VALUE(&SYSPREFIX *CAT 'MPMARC')              */ /*AR1084152A*/
/**********     CHGVAR     VAR(&XXMIDAS) VALUE('MIDAST8')            */ /*AR1084152*/ /*AR1084152A*/
/**Live*MPM archiving user */                                                         /*AR1084152*/
/**********  If         Cond(&SysPrefix = 'R8') Then(Do)                           */ /*AR1084152*/
/**********     CHGVAR     VAR(&XXMIDAS) VALUE('MIDASR8')                          */ /*AR1084152*/
/**********  Enddo                                                                 */ /*AR1084152*/
/* Live or Test user is determined by PGM RZ001120 */                                 /*AR1084152*/
             CHGVAR     VAR(&XXMIDAS) VALUE(&MMMUser)                                 /*AR1084152*/

             CALL       PGM(QSYGETPH) PARM(&XXMIDAS '*NOPWD    ' &HANDLE)
             CALL       PGM(QWTSETP) PARM(&HANDLE &ERRCODE)
/* Set MMM Archive Library */

             Addlible   Lib(&ArchMMMDb) Position(*First)
             Monmsg     Msgid(CPF2103) Exec(DO)
                Rmvlible   Lib(&ArchMMMDb)
                Addlible   Lib(&ArchMMMDb) Position(*First)
             Enddo

/* Set MMM Library */

             Addlible   Lib(&MainMMMDb) Position(*First)
             Monmsg     Msgid(CPF2103) Exec(DO)
                Rmvlible   Lib(&MainMMMDb)
                Addlible   Lib(&MainMMMDb) Position(*First)
             Enddo

/* Build SQL statement to execute */                                                  /*AR1084152*/
/* The correct target library (test or live) is already determined by RZ001120 */     /*AR1084152*/
             CHGVAR     VAR(&SQLSTMNT) VALUE('Call' *BCAT &MainMMMDb +
                           *TCAT '/Archiving_Tasks ()')                               /*AR1084152*/

/* Run Archive Procedure for correct system */
/**Test**                                   */                                        /*AR1084152*/
/********    If         Cond(&SysPrefix = 'T8') Then(Do)                           */ /*AR1084152*/
/********       Runsqlstm  Srcfile(RZSQLSRCZ) Srcmbr(CMMMARC_T8)                   */ /*AR1084152*/
/********    Enddo                                                                 */ /*AR1084152*/
/**Live**                                   */                                        /*AR1084152*/
/********    If         Cond(&SysPrefix = 'R8') Then(Do)                           */ /*AR1084152*/
/********       Runsqlstm  Srcfile(RZSQLSRCZ) Srcmbr(CMMMARC_R8)                   */ /*AR1084152*/
/********    Enddo                                                                 */ /*AR1084152*/
             RUNSQL     SQL(&SQLSTMNT)                                                /*AR1084152*/

/*********   Enddo      *********/

             Goto       CmdLbl(EndClPgm)

 Error:
             Chgjob     Sws(xxxxxx11)
             DmpClpgm

             Sndpgmmsg  MsgId(CPF9898) Msgf(QCPFMSG) MsgDta('Program RZC001125 +
                          ended abnormally - see job log') ToMsgq(Moperq MRunq)

             Sndpgmmsg  MsgId(CPF9898) Msgf(QCPFMSG) MsgDta('Program RZC001125 +
                          ended abnormally - see job log') MsgType(*Escape)

 EndClPgm:

             EndPgm
