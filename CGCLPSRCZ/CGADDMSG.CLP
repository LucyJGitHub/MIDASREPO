/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Create single message for CGPNARMSG')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGADDMSG - Add Multi-Language Posting Narratives Message    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      184382             Date 29Sep90              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 24Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       184382 - Missing info on message utility                    */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
   PGM        PARM(&LGID &MGNUM &MSGTXT)
 
   DCL        VAR(&LGID)   TYPE(*CHAR) LEN(2)
   DCL        VAR(&MGNUM)  TYPE(*CHAR) LEN(5)
   DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**ADDMSGD*   MSGID(&LGID *TCAT &MGNUM) MSGF(CGPNARMSG) MSG(&MSGTXT) +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10) (*CHAR 30) (*CHAR 6)  (*CHAR 3))                          /*CGL029*/
   ADDMSGD    MSGID(&LGID *TCAT &MGNUM) MSGF(CGPNARMSG) MSG(&MSGTXT) +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10) (*CHAR 30) (*CHAR 6)  (*CHAR 3))                          /*CGL029*/
   MONMSG     MSGID(CPF2412)                                          /*184382*/
 
             CHGVAR     VAR(&MSGTXT) VALUE(' ')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
