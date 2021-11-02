/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Save MPM Libraries')                                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC001120 - Save MPM Libraries                              */
/*                                                                   */
/*       Last Amend No. MD057372 *Create    Date 10Sep21             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057372 - Re-develop approach for MD-10209                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Note: This program saves the two MPM libraries              */
/*                                                                   */
/*********************************************************************/
             Pgm        Parm(&Component &Sequence)

/* Define variables */

             DCL        VAR(&JOBTYPE) TYPE(*CHAR)

             Dcl        Var(&MPlusDbPfx) Type(*CHAR) Len(2)
             Dcl        Var(&MainMPMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&ArchMPMDb ) Type(*CHAR) Len(10)
             Dcl        Var(&MplusDiLib) Type(*CHAR) Len(10)
             Dcl        Var(&Midasdate ) Type(*CHAR) Len(7)
             Dcl        Var(&MMMUser   ) Type(*CHAR) Len(10)

             Dcl        Var(&Today     ) Type(*Dec ) Len(5 0)
             Dcl        Var(&Tomorrow  ) Type(*Dec ) Len(5 0)
             Dcl        Var(&DayDiff   ) Type(*Dec ) Len(5 0)

             Dcl        Var(&Component)  Type(*Char) Len(10)
             Dcl        Var(&Sequence )  Type(*Dec ) Len(5 0)

/* Global message monitor */
             Monmsg     MsgId(CPF0000 MCH0000) Exec(Goto CmdLbl(Error))

             Chgjob     Sws(xxxxxx00)

/* Save Archive only when a CoB with non-working day */
             Call       Pgm(SC001450) Parm(&Today &Tomorrow)

             Chgvar     Var(&DayDiff) VALUE(&Tomorrow - &Today)

             If         Cond((&DayDiff  *Ne 1) *Or (&Sequence *Eq 1)) Then(Do)

/* Retrieve System Prefix */

                RtvDtaara  Dtaara(SdStat (6 2)) RtnVar(&MPlusDbPfx)
                RtvDtaara  Dtaara(Rundat (1 7)) RtnVar(&MidasDate )

/* Call program to determine libraries to be backed up */

                Call       Pgm(SC001120) Parm(&MPLusDbPfx &MainMPMDb &ArchMPMDb +
                             &MMMUser)

/* Check save files exist in DILIB then save */

                ChgVar     Var(&MPlusDiLib) Value(&MPlusDbPfx *CAT 'DILIB')

                If         Cond(&MainMPMDb *NE ' ') Then(Do)

                   ChkObj     Obj(&MainMPMDb) ObjType(*Lib)
                   ChkObj     Obj(&MPlusDiLib/&MainMPMDb) ObjType(*File)
                   Monmsg     MsgId(CPF9801) Exec(Do)

                      Crtsavf    File(&MPlusDiLib/&MainMPMDb) Text('Save file for +
                                   MPM main database')

                      GrtObjAut  OBJ(&MPlusDiLib/&MainMPMDb) ObjType(*File) +
                                   User(*Public) Aut(*All)
                   Enddo

                   Chgobjd    Obj(&MPlusDiLib/&MainMPMDb) ObjType(*File) +
                                Text(&MidasDate *CAT ' Save file for MPM main +
                                database')

                   Savlib     Lib(&MainMPMDb) Dev(*Savf) +
                                Savf(&MplusDiLib/&MainMPMDb) Clear(*All) +
                                OmitObj((Q*       *Dtaara) (Q*       *Jrnrcv)) +
                                Output(*Print)

                Enddo


/* Save Archive only when a CoB with non-working day */
                Call       Pgm(SC001450) Parm(&Today &Tomorrow)

                Chgvar     Var(&DayDiff) VALUE(&Tomorrow - &Today)

                If         Cond((&DayDiff  *Ne 1) *And (&Sequence *Ne 1)) Then(Do)

                   If         Cond(&ArchMPMDb *NE ' ') Then(Do)

                      ChkObj     Obj(&ArchMPMDb) ObjType(*Lib)
                      ChkObj     Obj(&MPlusDiLib/&ArchMPMDb) ObjType(*File)
                      Monmsg     MsgId(CPF9801) Exec(Do)

                         Crtsavf    File(&MPlusDiLib/&ArchMPMDb) Text('Save file +
                                      for MPM archive database')

                         GrtObjAut  OBJ(&MPlusDiLib/&ArchMPMDb) ObjType(*File) +
                                      User(*Public) Aut(*All)
                      Enddo

                      Chgobjd    Obj(&MPlusDiLib/&ArchMPMDb) ObjType(*File) +
                                   Text(&MidasDate *CAT ' Save file for MPM +
                                   Archive database')

                      Savlib     Lib(&ArchMPMDb) Dev(*Savf) +
                                   Savf(&MplusDiLib/&ArchMPMDb) Clear(*All) +
                                   OmitObj((Q*       *Dtaara) (Q*       *Jrnrcv)) +
                                   Output(*Print)

                   Enddo

                Enddo

             Enddo

             Goto       CmdLbl(EndClPgm)

/** Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(Error))
             GOTO       CMDLBL(EndClPgm)

 Error:
             Chgjob     Sws(xxxxxx11)
             DmpClpgm

             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC001120 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

 EndClPgm:

             EndPgm
