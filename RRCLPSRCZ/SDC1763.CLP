/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1763 - Display DSPDBR and then create MBRLIST for lgl's */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E13205             Date 14/02/89             */
/*                      E00000             Date 00/00/00             */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E13205 - For each Logical file in list add all its         */
/*                members to file MBRLIST member MBRLIST            */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(54)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/**/
             DCLF       FILE(*LIBL/QADSPDBR)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*           First twenty bytes represent the physical file          */
/**/
             CHGVAR     VAR(&FILE) VALUE(%SST(&PARM 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&PARM 11 10))
/**/
             SNDPGMMSG  MSG('SDC1763 - Rebuilding all access paths +
                          over file ' *BCAT &FILE *TCAT '.' *CAT +
                          &LIB) TOMSGQ(*LIBL/MRUNQ)
/**/
/*           Clear files in QTEMP                                    */
/**/
             CLRPFM     FILE(QTEMP/LOGICALS) MBR(REBUILD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MBRLIST) MBR(MBRLIST)
             MONMSG     MSGID(CPF0000)
/**/
/*           Display database relations for physical file            */
/**/
             DSPDBR     FILE(&LIB/&FILE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/LOGICALS) OUTMBR(REBUILD)
/**/
/*           Override file and read until end of file                */
/**/
             OVRDBF     FILE(QADSPDBR) TOFILE(QTEMP/LOGICALS) +
                          MBR(REBUILD)
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(REBUILD))
             IF         COND(&WHREFI *EQ ' ') THEN(GOTO CMDLBL(READ))
/**/
/*           Display member list via DSPFD and add to MBRLIST.QTEMP  */
/**/
             DSPFD      FILE(&WHRELI/&WHREFI) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/MBRLIST) +
                          OUTMBR(&WHREFI)
             CPYF       FROMFILE(QTEMP/MBRLIST) TOFILE(QTEMP/MBRLIST) +
                          FROMMBR(&WHREFI) TOMBR(MBRLIST) MBROPT(*ADD)
/**/
             GOTO       CMDLBL(READ)
/**/
/*           Call program SDC1764 to open and close each member in   */
/*           the list                                                */
/**/
 REBUILD:    CALL       PGM(*LIBL/SDC1764) PARM('MBRLIST' 'QTEMP' +
                          'MBRLIST')
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1763 - Display DSPDBR and +
                          then create MBRLIST for lgls - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
