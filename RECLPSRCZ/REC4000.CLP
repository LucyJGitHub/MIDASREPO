/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Generic object lock checker.')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4000 - Midas Cashier Generic object exclusive lock check.*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       PURPOSE: Receives parms Object name (10), Object type (10)  */
/*                and Return code (7).                               */
/*                Checks if the object is allocated by another       */
/*                process and returns FREE (object can be allocated),*/
/*                LOCKED (object is in use) or  NOOBJ (object was    */
/*                not found).                                        */
/*                If the object is locked it will also be freed.     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 194002  *CREATE    Date 06Jul01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       194002 - Check for object lock.                             */
/*                                                                   */
/*********************************************************************/
      PGM        PARM(&OBJECT &OBJTYPE &RTNCODE)
/**/
/**/
           DCL   VAR(&OBJECT) TYPE(*CHAR) LEN(10)
           DCL   VAR(&OBJTYPE) TYPE(*CHAR) LEN(10)
           DCL   VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
         MONMSG     MSGID(CPF0000)
 
         CHGVAR     VAR(&RTNCODE) VALUE('       ')
         ALCOBJ     OBJ((&OBJECT &OBJTYPE *EXCL)) WAIT(0)
             MONMSG   MSGID(CPF1085 CPF0939) EXEC(CHGVAR +
                      VAR(&RTNCODE) VALUE('NOOBJ  ')) /*NOT FOUND */
             MONMSG   MSGID(CPF1002) EXEC(CHGVAR VAR(&RTNCODE) +
                       VALUE('LOCKED '))        /* ALREADY LOCKED */
 
             IF         COND(&RTNCODE *EQ '       ') THEN(DO)
              CHGVAR VAR(&RTNCODE)  VALUE('FREE   ') /* ALLOCATED */
              DLCOBJ     OBJ((&OBJECT &OBJTYPE *EXCL))
                  MONMSG  CPF0000
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
