/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1766 - Rebuild access paths of files declared in *LDA   */
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
/*       New Program Overview                                       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E13205 - Files declared in 9 byte chunks, for each file    */
/*                call SDC1763 to rebuild paths                     */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&POSITION) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(450)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(54)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*           Set Up library prefix of *LIBL                          */
/**/
             CHGVAR     VAR(%SST(&PARM 11 10)) VALUE('*LIBL')
             RTVDTAARA  DTAARA(*LDA (1 450)) RTNVAR(&FILES)
/**/
/*           Loop through *LDA fifty times and call SDC1727          */
/**/
 LOOP:       IF         COND(&COUNT *LT 51) THEN(DO)
/**/
/*           Set up file name only if not blank                      */
/**/
             IF         COND(%SST(&FILES &POSITION 9) *NE ' ') THEN(DO)
             CHGVAR     VAR(%SST(&PARM 1 10)) VALUE(%SST(&FILES +
                          &POSITION 9))
/**/
/*           Call SDC1763 to rebuild access paths                    */
/**/
             CALL       PGM(*LIBL/SDC1763) PARM(&PARM)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
/**/
/*           Add 9 to position                                       */
/**/
             CHGVAR     VAR(&POSITION) VALUE(&POSITION + 9)
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
/**/
             GOTO       CMDLBL(LOOP)
/**/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1766 - Rebuild access paths +
                          of files declared in *LDA - ENDED +
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
