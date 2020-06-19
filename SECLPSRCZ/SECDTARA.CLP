000100200318/*********************************************************************/
000200200318/*STD    CLPBASE                                                     */
000300200318/*EXI    TEXT('Create Data Area to Monitor SE1806')                  */
000400200318/*********************************************************************/
000500200318/*                                                                   */
000600200318/*       Midas    - Securities Trading CL Module                     */
000700200318/*                                                                   */
000800200318/*       SECDTARA - Check TRADSDX2 File                              */
000900200318/*                                                                   */
001000200318/*       (c) Misys International Banking Systems Ltd. 2007           */
001100200318/*                                                                   */
001200200604/*       LAST Amend No. 248683  *CREATE    Date 22MAY20              */
001300200318/*                                                                   */
001400200318/*********************************************************************/
001500200318/*                                                                   */
001600200318/*       248683 -  Amended programs to check whether TRADSDX2 was    */
001700200318/*                 already written by SE1806.                        */
001800200318/*                                                                   */
001900200318/*********************************************************************/
002000200318             PGM        PARM(&PGMNAM &WRTFLG)
002100200318             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10)
002200200318             DCL        VAR(&WRTFLG) TYPE(*CHAR) LEN(1)
002300200318
002400200318/*           Check if DATA AREA SE1806FLG exists in QTEMP                     */
002500200318             CHKOBJ     OBJ(QTEMP/SE1806FLAG) OBJTYPE(*DTAARA)
002600200318             MONMSG     MSGID(CPF0000) EXEC(DO)
002700200318             CRTDTAARA  DTAARA(QTEMP/SE1806FLAG) TYPE(*CHAR) LEN(1) +
002800200318                          TEXT('SE1806 Flag for writing to +
002900200318                          TRADSDX2') AUT(*ALL)
003000200318             ENDDO
003100200318
003200200318/*           If Program Name is 'SETRADRPR' then clear data area              */
003300200318             IF         COND(&PGMNAM = 'SETRADRPR') THEN(DO)
003400200318
003500200318             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(' ')
003600200318
003700200318             ENDDO
003800200318
003900200318/*           If Program Name is 'SETRADUPC' then clear data area              */
004000200318             IF         COND(&PGMNAM = 'SETRADUPC') THEN(DO)
004100200318
004200200318             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(' ')
004300200318
004400200318             ENDDO
004500200318
004600200318/*           If Program Name is 'SE1806' then write value in data area        */
004700200318             IF         COND(&PGMNAM = 'SE1806') THEN(DO)
004800200318
004900200318             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(&WRTFLG)
005000200318
005100200318             ENDDO
005200200318
005300200318/*           If Program Name is 'SETRADUPD' then write value in data area      */
005400200318             IF         COND(&PGMNAM = 'SETRADUPD') THEN(DO)
005500200318
005600200318             RTVDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) RTNVAR(&WRTFLG)
005700200318
005800200318             ENDDO
005900200318
006000200318             ENDPGM
