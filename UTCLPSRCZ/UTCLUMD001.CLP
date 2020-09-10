/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Utility program to install FMD003 (Upgrade)')   */
/*OVR  : OVRDBF FILE(MEMLIST) TOFILE(QAFDMBRL)                      :*/
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   UTCLUMD001 -  Setup for installation of UMD003 (Upgrade |)      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. EML108             Date 24Jan20              */
/*       Prev Amend No. UMD001 * Create    Date 12Jan09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FB2.1SP21 (Recompile)                */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&HIBL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&AVBL) TYPE(*CHAR) LEN(6)

             DCLF       FILE(QTEMP/MEMLIST) /* File to receive +
                          list of members */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&LIB) VALUE(&PRE *CAT 'DMLIB')
             CHGVAR     VAR(&HIBL) VALUE(&PRE *CAT 'HIBL')
             CHGVAR     VAR(&AVBL) VALUE(&PRE *CAT 'AVBL')

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

/* Security Copy */
             CPYF       FROMFILE(GLHIBLPD) TOFILE(ZBIS/&HIBL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
             CPYF       FROMFILE(GLAVBLPD) TOFILE(ZBIS/&AVBL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

/* Remove members from the Management Accounts files                 */
             RMVM       FILE(GLHIBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLHIBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLHIBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLHIBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLHIBLL4) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)

             RMVM       FILE(GLAVBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLAVBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLAVBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)
             RMVM       FILE(GLAVBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7310 CPF7303 CPF7301)

             DSPFD      FILE(*LIBL/GLHIBLPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MEMLIST) OUTMBR(*FIRST +
                          *REPLACE)

             DSPFD      FILE(*LIBL/GLAVBLPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MEMLIST) OUTMBR(*FIRST +
                          *ADD)

             OVRDBF     FILE(MEMLIST) TOFILE(QTEMP/MEMLIST)

/* Review members of GLAVBLPD and GLHIBLPD                           */
             CALL       PGM(UTUMD001A)

/* Install deliverable data for FMD003                               */
             CALL       PGM(UTUMD001B)

/* Dump list of members into work file in QTEMP, too.                */
             DSPFD      FILE(*LIBL/GLHIBLPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/MEMLIST) +
                          OUTMBR(*FIRST *REPLACE)

 TAG1:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM)) /* +
                          end of file */

             CHKOBJ     OBJ(MCAVBLX0) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(MCAVBLX0) +
                          MBR(&MLNAME))
             CHKOBJ     OBJ(MCAVBLV0) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCAVBLV0) +
                          MBR(&MLNAME) DTAMBRS((MCAVBLX0 (&MLNAME))))
             CHKOBJ     OBJ(MCAVBLV1) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCAVBLV1) +
                          MBR(&MLNAME) DTAMBRS((MCAVBLX0 (&MLNAME))))
             CHKOBJ     OBJ(MCAVBV01) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCAVBV01) +
                          MBR(&MLNAME) DTAMBRS((MCAVBLX0 (&MLNAME))))

             CHKOBJ     OBJ(MCWORKX0) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(MCWORKX0) +
                          MBR(&MLNAME))
             CHKOBJ     OBJ(MCWORKV0) OBJTYPE(*FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCWORKV0) +
                          MBR(&MLNAME) DTAMBRS((MCWORKX0 (&MLNAME))))

             GOTO       CMDLBL(TAG1)

 ENDPGM:     ENDPGM
