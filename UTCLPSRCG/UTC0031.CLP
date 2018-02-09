/*********************************************************************/
/*XBI    OVRDBF FILE(CLRDBLIBAQ) TOFILE(QADSPOBJ)                    */
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT CLRDBLIB clear data areas and data queues')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0031 - Clear data areas and data queues from library     */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR796253           Date 30Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CSM002 *CREATE     Date 22Nov02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR796253 - Handle SQL sequences.                            */
/*       CPK018 - MidasPlus packaging.  Additional monitoring.       */
/*       CSM002 - Refresh options from the Bridge.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&FOUND) TYPE(*CHAR) LEN(1)                                  /*AR796253*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             DCLF       FILE(CLRDBLIBAQ)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Get list of all data areas and data queues in library. */
             DSPOBJD    OBJ(&LIB/*ALL) OBJTYPE(*DTAARA *DTAQ) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/CLRDBLIBAQ)
             MONMSG     MSGID(CPF2123) EXEC(DO)                                           /*CPK018*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CPK018*/
             ENDDO                                                                        /*CPK018*/
 
NEXTOBJECT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* If object is a data area. */
             IF         COND(&ODOBTP *EQ '*DTAARA') THEN(DO)
/* Call program to check if the data area is an SQL sequence. */                        /*AR796253*/
                CALL       PGM(UT000035) PARM(&ODOBNM &LIB &FOUND)                      /*AR796253*/
                IF         COND(&FOUND *EQ 'Y') THEN(DO)                                /*AR796253*/
                   CFGSQLSEQ  SEQ(&LIB/&ODOBNM) RESTART(1)                              /*AR796253*/
                   MONMSG     MSGID(SQL9010) EXEC(DO)                                   /*AR796253*/
                      GOTO       CMDLBL(ERROR)                                          /*AR796253*/
                   ENDDO                                                                /*AR796253*/
                ENDDO                                                                   /*AR796253*/
                ELSE       CMD(DO)                                                      /*AR796253*/
                CHGDTAARA  DTAARA(&LIB/&ODOBNM) VALUE(' ')
/* If CPF1019 received it data area is not a character. */
                MONMSG     MSGID(CPF1019) EXEC(DO)
                   CHGDTAARA  DTAARA(&LIB/&ODOBNM) VALUE(0)
                ENDDO
/* CPF101A means that it is a DDM data area. */
                MONMSG     MSGID(CPF101A)
             ENDDO
             ENDDO                                                                      /*AR796253*/
 
/* If object is a data queue. */
             IF         COND(&ODOBTP *EQ '*DTAQ') THEN(DO)
                CALL       PGM(QCLRDTAQ) PARM(&ODOBNM &LIB)
             ENDDO
 
             GOTO       CMDLBL(NEXTOBJECT)
 
             GOTO       CMDLBL(ENDPGM)
 
ERROR:
             CHGJOB     SWS(XXXXXX11)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
