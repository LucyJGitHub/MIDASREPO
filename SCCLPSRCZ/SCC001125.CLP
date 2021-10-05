/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Run MMM Archiving')                                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC001125 - Run MPM Archiving                               */
/*                                                                   */
/*       Last Amend No. MD057372  *Create    Date 10Sep21            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057372 - Re-develop approach for MD-10209                 */
/*                                                                   */
/*********************************************************************/
             Pgm

/** Define variables */

             Dcl        Var(&MPlusDbPfx) Type(*CHAR) Len(2)
             Dcl        Var(&MainMMMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&ArchMMMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&MplusDiLib) Type(*CHAR) Len(10)
             Dcl        Var(&Midasdate ) Type(*CHAR) Len(7)
             Dcl        Var(&MMMUser   ) Type(*CHAR) Len(10)

             Dcl        Var(&Today     ) Type(*Dec ) Len(5 0)
             Dcl        Var(&Tomorrow  ) Type(*Dec ) Len(5 0)
             Dcl        Var(&DayDiff   ) Type(*Dec ) Len(5 0)
             DCL        VAR(&XXMIDAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SQLSTMNT) TYPE(*CHAR) LEN(40)
             DCL        VAR(&HANDLE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ERRCODE) TYPE(*CHAR) LEN(8) VALUE(X'0000000000000000')

/* Global message monitor */
             Monmsg     MsgId(CPF0000 MCH0000) Exec(Goto CmdLbl(Error))

             Chgjob     Sws(xxxxxx00)

/* Save Archive only when a CoB with non-working day */
             Call       Pgm(SC001450) Parm(&Today &Tomorrow)

             Chgvar     Var(&DayDiff) VALUE(&Tomorrow - &Today)


/* Retrieve System Prefix */

             RtvDtaara  Dtaara(SdStat (6 2)) RtnVar(&MPlusDbPfx)
             RtvDtaara  Dtaara(Rundat (1 7)) RtnVar(&MidasDate )

/* Call program to determine libraries to be backed up */

             Call       Pgm(SC001120) Parm(&MPLusDbPfx &MainMMMDb &ArchMMMDb +
                          &MMMUser)
/* Transfer job control to MPM archiving user xxMPMARC */
/* Live or Test user is determined by PGM SC001120 */
             CHGVAR     VAR(&XXMIDAS) VALUE(&MMMUser)

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

/* Run Archive Procedure for correct system */
             CALL       PGM(SC001451)

             Goto       CmdLbl(EndClPgm)

 Error:
             Chgjob     Sws(xxxxxx11)
             DmpClpgm

             Sndpgmmsg  MsgId(CPF9898) Msgf(QCPFMSG) MsgDta('Program SCC001125 +
                          ended abnormally - see job log') ToMsgq(Moperq MRunq)

             Sndpgmmsg  MsgId(CPF9898) Msgf(QCPFMSG) MsgDta('Program SCC001125 +
                          ended abnormally - see job log') MsgType(*Escape)

 EndClPgm:

             EndPgm
