/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP OTU CPYSRC')                                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC20356- OTU CPYSRC                                        */
/*                                                                   */
/*       Function: This program performs the CPYSRC similar to       */
/*                 UPC2035.                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CUP044   *CREATE   Date 22May22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP044 - One Touch Bridge Automation Changes - Release/     */
/*                Patch Upgrade                                      */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&TOLIB)                                                   */ /*CPK016*/
/**********  PGM                                                            */ /*CPK016*/ /*CPK018*/
/**********  PGM        PARM(&LAYER)                                        */ /*CPK018*/ /*CUP033*/
             PGM        PARM(&LAYER &SRCSVAL &PRFX)                                       /*CUP033*/

             DCL        VAR(&SRCSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*             */ /*CUP033*/
             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
/**********  DCLF       FILE(UPGSVALJ0) */                                     /*CUP033* *MD054605*/
             DCLF       FILE(UPGSVALJ0) ALWNULL(*YES)                                   /*MD054605*/

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create data area /MIDASMSG in QTEMP */                                                 /*CPK015*/
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)                                            /*CPK015*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')                                                      /*CPK015*/

/************DLTF       FILE(QTEMP/FROMLIB)                                            */ /*CPK016*/
/************MONMSG     MSGID(CPF2105)                                                 */ /*CPK016*/

/* Obtain 'From Library' name from BRIDGE ICD file */
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CUP024*/ /*CUP033*/

/**********  IF         COND(&PTFSRC *EQ *BLANKS) THEN(DO)                             */ /*CUP033*/

VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &SRCSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFSRC) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                GOTO       CMDLBL(ABNOR)
             ENDDO

/**Obtain*list*of*files*in*'From*Library'**/ /*                                        */ /*CPK016*/
/************DSPOBJD    OBJ(&PTFSRC/*ALL) OBJTYPE(*FILE) +                             */ /*CPK016*/
/************             OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMLIB)                      */ /*CPK016*/

/* Perform copy of Source files */
/************CALL       PGM(UPC0035) PARM(&PTFSRC &TOLIB)                              */ /*CPK016*/
/**********  CPYCPYSRC  FROMLIB(&PTFSRC) ??TOLIB()                          */ /*CPK016*/ /*CPK018*/
             IF         COND(&LAYER *EQ '*GLOBAL') THEN(DO)
                   CHGVAR     VAR(&TOLIB) VALUE(&PRFX *CAT 'GIRLIB')
             enddo
             ELSE cmd(do)
                   CHGVAR     VAR(&TOLIB) VALUE(&PRFX *CAT 'IRLIB')
             enddo

             CPYCPYSRC6  FROMLIB(&PTFSRC) TOLIB(&TOLIB) LAYER(&LAYER)
             MONMSG     MSGID(CPF6801)                                                    /*CPK016*/

             GOTO       CMDLBL(END)
 ABNOR:
            CHGJOB     SWS(XXXXXX11)
            DMPCLPGM

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
