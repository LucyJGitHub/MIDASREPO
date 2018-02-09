/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Display Object Locks')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCDOBJLCK - Display Object Locks                            */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021351           Date 06May14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG3834 *CREATE    Date 18Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021351 - Design for Kill object locks                     */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG3834 - New programs created to deal with object locks    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OBJ &LIB &OBJTYPE &PRINT)
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRINT)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PIMMED) TYPE(*CHAR) VALUE('Y')                             /*MD021351*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDP))
             DLTF       FILE(QTEMP/OBJLCK)
             MONMSG     MSGID(CPF0000)
/**********  CALL       PGM(SCCOBJLCKR) PARM(&OBJ &LIB &OBJTYPE +
                          'OBJLCK' 'QTEMP') */                                          /*MD021351*/
             CALL       PGM(SCCOBJLCKR) PARM(&OBJ &LIB &OBJTYPE +
                          'OBJLCK' 'QTEMP' &PIMMED)                                     /*MD021351*/
             IF         COND(&PRINT =  '*PRINT') THEN(DO)
             CPYF       FROMFILE(QTEMP/OBJLCK) TOFILE(*PRINT) +
                          OUTFMT(*CHAR)
             ENDDO
/**********  IF         COND(&PRINT**= '*PRINT') THEN(DO)            */                  /*BG18886*/
             IF         COND(&PRINT *NE '*PRINT') THEN(DO)                               /*BG18886*/
             DSPPFM     FILE(QTEMP/OBJLCK)
             ENDDO
ENDP:        ENDPGM
