/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AO CL to delete dataqueues')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Access Objects Module                       */
/*                                                                   */
/*       AOC8001 - DELETE DATAQUEUES                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015            Date 18Apr02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408            Date 04May95               */
/*                      042167            Date 12May93               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - 4.01 pacakaging.  Use DPLIB and not DILIB.         */
/*       S01408 - Addition Of Core Hook AOC8001MPS                   */
/*       CREATED FOR E42167 - CL PROGRAM FOR RECORD LOCKING          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/**/
/*           Copyright statement definition                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
             DCLF       FILE(QADSPOBJ)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DPLIB')                         /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AOC8001MPS                                          */
                                                                      /*S01408*/
/* */
/*       Check for all the *dtaara objects                           */
/* */
             DSPOBJD    OBJ(&DILIB/*ALL) OBJTYPE(*DTAARA) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/DTAFILE)
/* */
/*       Check for no objects                                        */
/* */
             MONMSG     MSGID(CPF2105 CPF2123 ) EXEC(GOTO CMDLBL(END))
/* */
/*       Perform override                                            */
/* */
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DTAFILE)
/* */
 READ:       RCVF
/* */
/*       Check for end of file                                       */
/* */
             MONMSG     MSGID(CPF0864 ) EXEC(GOTO CMDLBL(END))
/* */
/*       Delete data area if it is 'Allocation dataarea'             */
/* */
             IF         COND(&ODOBTX *EQ 'Allocation dataarea') +
                          THEN(DO)
             DLTDTAARA  DTAARA(&DILIB/&ODOBNM)
             ENDDO
/* */
             GOTO CMDLBL(READ)
/* */
 ABNOR:      SNDPGMMSG  MSG('AOC8001 - Ended Abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
