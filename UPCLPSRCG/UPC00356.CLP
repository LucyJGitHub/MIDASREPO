/*********************************************************************/
/*OVR    OVRDBF FILE(FROMLIB) TOFILE(QADSPOBJ)                       */
/*STD    CLPBASEBND                                                  */
/*EXI    TEXT('Midas UP OTU copy source')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC00356 - OTU copy source                                  */
/*                                                                   */
/*       Function: This program performs the source copy similar to  */
/*                 UPC0035.                                          */
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
/**********  PGM        PARM(&PTFSRC &TOLIB)                                           */ /*CPK018*/
             PGM        PARM(&PTFSRC &TOLIB &LAYER)                                       /*CPK018*/

             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
             DCL        VAR(&ODOSBS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCLF       FILE(QTEMP/FROMLIB)

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Obtain list of files in 'From Library' */                                              /*CPK016*/
             DLTF       FILE(QTEMP/FROMLIB)                                               /*CPK016*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK016*/
             DSPOBJD    OBJ(&PTFSRC/*ALL) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMLIB)                         /*CPK016*/

/* Obtain 'From Library' name from BRIDGE ICD file */
 LOOP:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))

             CHGVAR     VAR(&ODOSBS) VALUE(%SST(&ODOBNM 3 8))

/* Copy for zone layer. */                                                                /*CPK018*/
             IF         COND(&LAYER *EQ '*ZONE') THEN(DO)                                 /*CPK018*/
/**********     IF         COND(&ODOBNM *EQ 'QWINDSRC' *OR &ODOBNM *EQ +
                             'STDCRTPARM' *OR &ODOBNM *EQ 'ZSRSRC' *OR +
                             &ODOSBS *EQ 'CPYSRC') THEN(DO) */                          /*MD059874*/
                IF         COND(&ODOBNM *EQ 'QWINDSRC' *OR &ODOBNM *EQ +
                             'STDCRTPARM' *OR &ODOBNM *EQ 'ZSRSRC' *OR +
                             &ODOSBS *EQ 'CPYSRC' *OR +
                             &ODOSBS *EQ 'CPYSRCZ')  THEN(DO)                           /*MD059874*/

/************   CPYF       FROMFILE(&PTFSRC/&ODOBNM) +                                 */ /*CPK016*/
/************                TOFILE(&TOLIB/&ODOBNM) FROMMBR(*ALL) +                    */ /*CPK016*/
/************                TOMBR(*FROMMBR) MBROPT(*REPLACE) +                        */ /*CPK016*/
/************                CRTFILE(*YES)                                             */ /*CPK016*/
                   MOVMBR     FILE(&PTFSRC/&ODOBNM) MBR(*ALL) +
                                TOLIB(&TOLIB) LEAVE(*YES)                                 /*CPK016*/

                ENDDO
             ENDDO                                                                        /*CPK018*/

/* Copy for global layer. */                                                              /*CPK018*/
             IF         COND(&LAYER *EQ '*GLOBAL') THEN(DO)                               /*CPK018*/
/**********     IF         COND(&ODOBNM *EQ 'QWINDSRCG' *OR &ODOSBS *EQ +              */ /*CUP099*/
/**********                  'CPYSRCG') THEN(DO)                            */ /*CPK018*/ /*CUP099*/
                IF         COND(&ODOBNM *EQ 'QWINDSRCG' *OR &ODOSBS *EQ +
                             'CPYSRCG' *OR &ODOBNM *EQ 'STDCRTPARM') +
                             THEN(DO)                                                     /*CUP099*/
                   MOVMBR     FILE(&PTFSRC/&ODOBNM) MBR(*ALL) +
                                TOLIB(&TOLIB) LEAVE(*YES)                                 /*CPK018*/
                ENDDO                                                                     /*CPK018*/
             ENDDO                                                                        /*CPK018*/

             GOTO       CMDLBL(LOOP)

             GOTO       CMDLBL(END)
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
