/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Add binding directory entries')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC9006 - Add Binding Directory entries                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK022             Date 29Jul05              */
/*                      CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      141051 *CREATE     Date 07Oct98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       141051 - Add Binding Directory entries specifying *LIBL     */
/*                rather than the library name                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BNDDIRLIB &BNDDIR &OBJLIB &OBJTYP +
                          &POSITION)
 
             DCL        VAR(&BNDDIRLIB) TYPE(*CHAR) LEN(10) /* +
                          Binding directory lbrary */
             DCL        VAR(&BNDDIR) TYPE(*CHAR) LEN(10) /* +
                          Binding directory name  */
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10) /* Library +
                          containing modules and sevice programs */
             DCL        VAR(&OBJTYP) TYPE(*CHAR) LEN(7) /* Which +
                          object type(s) to include */
             DCL        VAR(&POSITION) TYPE(*CHAR) LEN(6) /* Where +
                          to add entries */
 
/***COPY*UTCPYSRC,STDERR_DCL                                          */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR_DCL                                          */                  /*CPK022*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(QADSPOBJ)
 
/*/COPY WNCPYSRC,UTC9006INT                                          */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,UTC9006MPS                                          */
 
/* Generate a file of all of the items of the specified type (*MODULE +
   or *SRVPGM) in the specified library                             */
 
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/UTC9006)
 
             DLTF       FILE(QTEMP/UTC9006)
             MONMSG     MSGID(CPF2105)
 
             DSPOBJD    OBJ(&OBJLIB/*ALL) OBJTYPE(&OBJTYP) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UTC9006)
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END))
 
/* Add each one to the binding directory at a time, using *LIBL +
   rather than the specified library name                        */
 
ADDLOOP01:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             ADDBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                          OBJ((*LIBL/&ODOBNM &OBJTYP)) +
                          POSITION(*LAST)
 
             GOTO       CMDLBL(ADDLOOP01)
 
 ABNOR:
/*/COPY WNCPYSRC,UTC9006ERR                                          */
 
/***COPY*UTCPYSRC,STDERR                                              */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR                                              */                  /*CPK022*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC9006END                                          */
 
             ENDPGM
