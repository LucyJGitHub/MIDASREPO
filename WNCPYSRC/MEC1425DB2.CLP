     /*****************************************************************/
     /*                                                               */
     /*  Last Amend No. MD031937           Date 13Jan15               */
     /*  Prev Amend No. AR856737           Date 13Sep11               */
     /*                  ESL044 *Create         Date 01Feb2005        */
     /*                                                               */
     /*****************************************************************/
     /*                                                               */
     /*  MD031937 - Upgrade STP enhancements to BF Midas 2.1          */
     /*  AR856737 - Upgrade STP enhancements to Midas Plus level      */
     /*  ESL044 - Cob load of BIC Plus                                */
     /*                                                               */
     /*****************************************************************/

/* Get Data from CD                   */

/* Create temporary file              */
             CRTPF      FILE(&DPLIB/SWIFTBICPL) RCDLEN(1248) +
                          SIZE(*NOMAX) AUT(*ALL)
             MONMSG     MSGID(CPF7302)

             CLRPFM     FILE(&DPLIB/SWIFTBICPL)

/* Retrieve path from MEBICPLOAD      */
             RTVDTAARA  DTAARA(MEBICPLOAD (1 100)) RTNVAR(&FROMLOC)

/* From location - General            */
             IF         COND(&FROMLOC = ' ') THEN(DO)
             CHGVAR     VAR(&P_RTNPATH) VALUE('/QOPT/BICPLUS/EBCDIC')
             ENDDO

/* Get EBCDIC file name               */
             CALL       PGM(MEP1426) PARM(&P_RTNCODE &P_RTNSTMF +
                          &P_RTNPATH)

             IF         COND((&P_RTNCODE *NE ' ') *OR +
                             (&P_RTNPATH *EQ ' ')) THEN(DO)

             SNDPGMMSG  MSG('No data to extract for SWIFT BIC load') +
                          TOMSGQ(MOPERQ MRUNQ)

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             GOTO       CMDLBL(ENDCLPGM)

             ENDDO

/* To location                        */
             CHGVAR     VAR(&TOLOC) VALUE('/QSYS.LIB/' *TCAT +
                          &DPLIB *TCAT +
                          '.LIB/SWIFTBICPL.FILE/SWIFTBICPL.MBR')

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Copying +
                          data from ' *CAT &P_RTNPATH *BCAT ' tp ' +
                          *CAT &TOLOC *BCAT ' ....')

/* Copy from CD EBCDIC Data           */

             CPYFRMSTMF FROMSTMF(&P_RTNPATH) TOMBR(&TOLOC) +
                          MBROPT(*REPLACE) CVTDTA(*NONE) +
                          ENDLINFMT(*FIXED) TABEXPN(*NO)

/* Copy to METIC* files               */

             CPYF       FROMFILE(&DPLIB/SWIFTBICPL) +
                          TOFILE(&DPLIB/METICVPD) MBROPT(*REPLACE) +
                          NBRRCDS(1) FMTOPT(*NOCHK)

             CPYF       FROMFILE(&DPLIB/SWIFTBICPL) +
                          TOFILE(&DPLIB/METICPPD) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ 'FI') FMTOPT(*NOCHK)

             CPYF       FROMFILE(&DPLIB/SWIFTBICPL) +
                          TOFILE(&DPLIB/METICCPD) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ 'CT') FMTOPT(*NOCHK)

     /*****************************************************************/
     /* End of MEC1425DB2                                             */
     /*****************************************************************/
