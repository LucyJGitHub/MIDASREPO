/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check Object Existance Exec user program')      */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/*     SD9251C - CHECK OBJECT EXISTANCE                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.  XXXXXX           DATE  XXXXXXX               */
/*                                                                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     XXXXXX  -  XXXXXXXXXXXXXXXXXXXXXXXX                          */
/*                                                                  */
/********************************************************************/
/**                                                                 **/
             PGM        PARM(&OBJ &OBJT &RTN)
 
   /**      Declare the parameters and Variables **/
 
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
  /**        CHANGE THE DEVICE DESCRIPTION FOR A TAPE DEVICE. **/
  /**        IF THE DEVICE DESCRIPTION IS NOT A CORRECT TYPE, **/
  /**        IT WILL NOT BE CHANGED AND AN ESCAPE MESSAGE     **/
  /**        EQUAL TO (CPF2618) WILL BE SENT.                 **/
  /**        IF ESCAPE MESSAGE (CPF2618) IS DETECTED, ASSIGN  **/
  /**        THE VALUE 'OBJERR' TO THE RETURN CODE.           **/
 
             IF   COND(&OBJT  *EQ  '*DEVD')  THEN(DO)
 
             CHGDEVTAP  DEVD(&OBJ)
             MONMSG     MSGID(CPF2618) EXEC(CHGVAR VAR(&RTN) +
                          VALUE('OBJERR'))
             ENDDO
 
             ELSE       CMD(DO)
 
  /** Call the IBM command check object (CHKOBJ) passing parameters **/
  /** OBJ (Object) and OBJT (Object type) to it,                    **/
  /** using *LIBL for the specified object.                         **/
  /** If escape message Id is equal to (CPF9801)                    **/
  /** assign the value 'OBJERR' to the return code.                 **/
 
             CHKOBJ     OBJ(&OBJ) OBJTYPE(&OBJT)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                 CHGVAR     VAR(&RTN) VALUE('OBJERR')
                 ENDDO
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
