/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE CREATE SHADOW POSTINGS')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                LEC0901 - CREATE SHADOW POSTINGS                  */
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
/*       Prev Amend No. 105140             Date 18Nov96              */
/*                      S01194             Date 07Feb90              */
/*                      E17849              DATE  20JUL89           */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       105140 - Recompile over changed LVENTZZ.                   */
/*       S01194 - NEW STANDING DATA                                 */
/*       E17849 - DO NOT CALL LE0820 IF LVENT IS EMPTY.             *  *E17849*/
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
/*                                                             E17849*/
             DCLF FILE(LVENTZZ)
/*                                                             E17849*/
/**/
             SNDPGMMSG  MSG('CUSTOMER LENDING SHADOW POSTINGS') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(RPOSTHH)
             CLRPFM     FILE(RPOSTPD)
             CLRPFM     FILE(RPOSTZZ)
/**/
/*                                                             E17849*/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
/*                                                             E17849*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)      */           /*S01194*/
             CALL       PGM(LE0820)
/**/
             CHGJOB     SWS(0XXXXXXX)
/**/
/*                                                             E17849*/
/*********** ENDPGM*/
 ENDPGM:     ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*                                                             E17849*/
