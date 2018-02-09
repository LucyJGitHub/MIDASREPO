/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Access SDMEXPPD with CLOSE')                 */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0045 - Access SDMEXPPD with CLOSE                       */
/*                                                                  */
/*       Function : This program areads PF/SDMEXPPD.  Unlike the    */
/*                  access object it always reads the file, and     */
/*                  therefore picks up changes immediately          */
/*                                                                  */
/*       Called by: ED0040                                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01493 *CREATE     DATE 06JUN94             */
/*                      Xnnnnn             DATE ddmmmyy             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01493 - Midas Export Data Interface Module                */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&E7DFEN &E7DFWT)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Other declarations */
 
             DCLF       FILE(SDMEXPPD)
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCVF
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination */
 
ABNOR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS('XXXXXX11')
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
