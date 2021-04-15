/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('TI Exposure Reports Utility')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utility                                             */
/*                                                                   */
/*       UTCGO0539 - TI Exposure Reports                             */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. AR318278 *CREATE   Date 04Oct10              */
/*                                                                   */
/*       Note: This program may run in three modes:                  */
/*             Mode 'A' - TI exposure with Zero balance              */
/*             Mode 'B' - TI exposure with Non-zero balance          */
/*             Mode 'C' - TI exposure without Maturity date          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR318278 - TI exposure reports.                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)

/* Global Monmsg */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Call Audit report program */

             IF         COND(&MODE *EQ 'A' *OR &MODE *EQ 'B' *OR +
                          &MODE *EQ 'C') THEN(CALL PGM(UTGO0539) +
                          PARM(&MODE))

             SELECT
             WHEN       COND(&MODE *EQ 'A') THEN(DO)
             CHGSPLFA   FILE(UTGO0539P1) SPLNBR(*LAST) USRDTA('MODE A')
               SNDUSRMSG  MSG('"TI Exposure with Zero Balance" report +
                            is generated') MSGTYPE(*INFO)
             ENDDO
             WHEN       COND(&MODE *EQ 'B') THEN(DO)
             CHGSPLFA   FILE(UTGO0539P1) SPLNBR(*LAST) USRDTA('MODE B')
               SNDUSRMSG  MSG('"TI Exposure with Non-zero Balance" +
                            report is generated') MSGTYPE(*INFO)
             ENDDO
             WHEN       COND(&MODE *EQ 'C') THEN(DO)
             CHGSPLFA   FILE(UTGO0539P1) SPLNBR(*LAST) USRDTA('MODE C')
               SNDUSRMSG  MSG('"TI Exposure with no Maturity date" +
                            report is generated') MSGTYPE(*INFO)
             ENDDO
             ENDSELECT

             GOTO       CMDLBL(END)

 ABNOR:      SNDUSRMSG  MSG('Program UTCGO0539 ended abnormally. See +
                          previous joblog entry.') MSGTYPE(*INFO)

 END:        ENDPGM
