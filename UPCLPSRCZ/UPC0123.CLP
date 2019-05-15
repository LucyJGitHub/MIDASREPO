/*********************************************************************/
/*XBI    OVRDBF FILE(UPJOBDOF) TOFILE(QADSPOBJ)                      */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change system job descs. JOBQs and OUTQs')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0123 - Change system's job descriptions                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK017             Date 13Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP013 *C *CREATE  Date 10Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK017 - Release 5 packaging.  Change job descriptiom       */
/*                user too.                                          */
/*       CUP013 - New program to change libraries for a job          */
/*                 description's job queue and output queue.         */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&ERROR)                                                   */ /*CPK017*/
             PGM        PARM(&OWNER &ERROR)                                               /*CPK017*/
 
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK017*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(UPJOBDOF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
READ:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/* Retrieve job description details. */
             RTVJOBD    JOBD(&ODOBNM) JOBQ(&JOBQ) OUTQ(&OUTQ)
 
/* If output queue has special value then only change job queue and user. */
             IF         COND(%SST(&OUTQ 1 1) *EQ '*') THEN(DO)
/**********     CHGJOBD    JOBD(&ODOBNM) JOBQ(*LIBL/&JOBQ)                             */ /*CPK017*/
                CHGJOBD    JOBD(&ODOBNM) JOBQ(*LIBL/&JOBQ) USER(&OWNER)                   /*CPK017*/
                GOTO       CMDLBL(READ)
             ENDDO
 
/**********  CHGJOBD    JOBD(&ODOBNM) JOBQ(*LIBL/&JOBQ) +                              */ /*CPK017*/
/**********               OUTQ(*LIBL/&OUTQ)                                            */ /*CPK017*/
             CHGJOBD    JOBD(&ODOBNM) JOBQ(*LIBL/&JOBQ) +
                          OUTQ(*LIBL/&OUTQ) USER(&OWNER)                                  /*CPK017*/
 
             GOTO       CMDLBL(READ)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGVAR     VAR(&ERROR) VALUE('Y')
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
