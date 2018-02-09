/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC SAR maintenance replication feature')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0430 - Replicate data for Switchable Feature             */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG10771 *CREATE   Date 12Apr06              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG10771 - Automatically replicate SFMENUPD to GZSFMENUPD   */
/*                  and SCSARDPD to GZSCSARDPD.                      */
/*                  Then call APCCRTNDFL                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c)  +
                          Finastra International Limited +
                          2006')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Call GOC0100 - GO Bulk synchronization of global layer            */
 
             CALL       PGM(GOC0100) PARM('GZSFMENUPD')
 
             CALL       PGM(GOC0100) PARM('GZSCSARDPD')
 
/* Call APCCRTNDFL - Midas AP Create non-display field list          */
 
             CALL       PGM(APCCRTNDFL)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
