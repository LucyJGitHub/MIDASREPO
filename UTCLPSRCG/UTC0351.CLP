/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for CHGCCSIDS')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0351 - Validity checker for CHGCCSIDS (Change CCSIDs)    */
/*                 command                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK022             Date 28Jul05              */
/*                      CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      113280             Date 10Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA005 *CREATE     Date 02AUG96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       113280 - Fails because command parameter is decimal and     */
/*                 input parameter is character.                     */
/*       CAA005 - This program checks the validity of the data       */
/*                passed to the CHGCCSIDS command.                   */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&LIB &FILE &NEWCCSID)                                     */ /*113280*/
             PGM        PARM(&LIB &FILE &NEWCCSIDN)                                       /*113280*/
 
/*/COPY WNCPYSRC,UTC0351INT                                          */
 
/** Parameters **/
 
/** Library **/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/** File **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
/** New CCSID **/
/************DCL        VAR(&NEWCCSID) TYPE(*CHAR) LEN(5)                              */ /*113280*/
             DCL        VAR(&NEWCCSIDN) TYPE(*CHAR) LEN(5)                                /*113280*/
 
/** Non-parameter variables **/
 
/** Result returned from QCLSCAN **/
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
 
/** Standard fields **/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**COPY UTCPYSRC,DCL_EXIST                                           */                   /*CPK022*/
/**COPY UTCPYSRC,DCL_MSG                                             */                   /*CPK022*/
/**COPY UTCPYSRC,DCL_STATUS                                          */                   /*CPK022*/
/**COPY UTCPYSRC,STDERR_DCL                                          */                   /*CPK022*/
/*/COPY GPCPYSRCG,DCL_EXIST                                           */                  /*CPK022*/
/*/COPY GPCPYSRCG,DCL_MSG                                             */                  /*CPK022*/
/*/COPY GPCPYSRCG,DCL_STATUS                                          */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR_DCL                                          */                  /*CPK022*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,UTC0351MPS                                          */
 
/** Check that library exists **/
 
             CHGVAR     VAR(&OBJLIB) VALUE('QSYS')
             CHGVAR     VAR(&OBJ) VALUE(&LIB)
             CHGVAR     VAR(&OBJTYPE) VALUE('*LIB')
             CHGVAR     VAR(&AUT) VALUE('*ALL')
/**COPY*UTCPYSRC,OBJEXIST                                            */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJEXIST                                            */                  /*CPK022*/
             IF         COND(&OBJEXISTS *EQ 'N') THEN(DO)
/**COPY*UTCPYSRC,OBJEXMSGN                                           */
/**COPY*UTCPYSRC,SNDCPD0006                                          */
/*/COPY GPCPYSRCG,OBJEXMSGN                                           */                  /*CPK022*/
/*/COPY GPCPYSRCG,SNDCPD0006                                          */                  /*CPK022*/
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/** If it exists, check that the user has *ALL authority to it. **/
/**COPY*UTCPYSRC,OBJAUTCHK                                           */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJAUTCHK                                           */                  /*CPK022*/
             IF         COND(&AUTOK *EQ 'N') THEN(DO)
/**COPY*UTCPYSRC,OBJAUTMSG                                           */
/**COPY*UTCPYSRC,SNDCPD0006                                          */
/*/COPY GPCPYSRCG,OBJAUTMSG                                           */                  /*CPK022*/
/*/COPY GPCPYSRCG,SNDCPD0006                                          */                  /*CPK022*/
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/** +
    If a single file name was selected, check that it exists.       +
    Scan for an asterisk to determine whether *ALL or a generic was +
    entered.                                                        +
**/
             CALL       PGM(QCLSCAN) PARM(&FILE X'010F' X'001F' +
                            '*' X'001F' '0' '0' '' &RESULT)
 
/** +
    If result is zero, no asterisk was found; a single file was +
    specified.  Check its existence and authority.              +
**/
             IF         COND(&RESULT *EQ 0) THEN(DO)
 
                CHGVAR     VAR(&OBJLIB) VALUE(&LIB)
                CHGVAR     VAR(&OBJ) VALUE(&FILE)
                CHGVAR     VAR(&OBJTYPE) VALUE('*FILE')
                CHGVAR     VAR(&AUT) VALUE('*ALL')
/**COPY*UTCPYSRC,OBJEXIST                                            */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJEXIST                                            */                  /*CPK022*/
                IF         COND(&OBJEXISTS *EQ 'N') THEN(DO)
/**COPY*UTCPYSRC,OBJEXMSGN                                           */                   /*CPK022*/
/**COPY*UTCPYSRC,SNDCPD0006                                          */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJEXMSGN                                           */                  /*CPK022*/
/*/COPY GPCPYSRCG,SNDCPD0006                                          */                  /*CPK022*/
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
/** If it exists, check that the user has *ALL authority to it. **/
/**COPY*UTCPYSRC,OBJAUTCHK                                           */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJAUTCHK                                           */                  /*CPK022*/
                IF         COND(&AUTOK *EQ 'N') THEN(DO)
/**COPY*UTCPYSRC,OBJAUTMSG                                           */                   /*CPK022*/
/**COPY*UTCPYSRC,SNDCPD0006                                          */                   /*CPK022*/
/*/COPY GPCPYSRCG,OBJAUTMSG                                           */                  /*CPK022*/
/*/COPY GPCPYSRCG,SNDCPD0006                                          */                  /*CPK022*/
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
             ENDDO
 
 
/*/COPY WNCPYSRC,UTC0351MPE                                          */
 
             GOTO       CMDLBL(END)
 
ERROR:
/**COPY*UTCPYSRC,VC_END                                              */                   /*CPK022*/
/*/COPY GPCPYSRCG,VC_END                                              */                  /*CPK022*/
             RETURN
 
 ABNOR:
 
/*/COPY WNCPYSRC,UTC0351ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/**COPY*UTCPYSRC,STDERR                                              */                   /*CPK022*/
/*/COPY GPCPYSRCG,STDERR                                             */                   /*CPK022*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC0351END                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
