/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for APYJOBDLBL')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0043_VC - Apply library list from a job description to   */
/*                     current job validity checker                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC017  *CREATE    Date 14Feb03              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC017 - Change to 250 library list.                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBDFULL)
 
             DCL        VAR(&JOBDFULL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBDLB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/*/COPY UTCPYSRC,DCL_EXIST                                        */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Split qualified JOBD string into its component parts */
             CHGVAR     VAR(&JOBD)   VALUE(%SST(&JOBDFULL  1 10))
             CHGVAR     VAR(&JOBDLB) VALUE(%SST(&JOBDFULL 11 10))
 
/* Check existence of the library (if not *LIBL) */
             IF         COND(&JOBDLB *NE '*LIBL') THEN(DO)
                CHGVAR     VAR(&OBJLIB)  VALUE('QSYS')
                CHGVAR     VAR(&OBJTYPE) VALUE('*LIB')
                CHGVAR     VAR(&OBJ) VALUE(&JOBDLB)
 
/*/COPY UTCPYSRC,OBJEXIST                                         */
 
/* If the library does not exist */
 
                IF         COND(&OBJEXISTS *EQ 'N') THEN(DO)
 
/*/COPY UTCPYSRC,OBJEXMSGN                                        */
 
                ENDDO
             ENDDO
 
/* Check existence of the job description */
                CHGVAR     VAR(&OBJLIB)  VALUE(&JOBDLB)
                CHGVAR     VAR(&OBJTYPE) VALUE('*JOBD')
                CHGVAR     VAR(&OBJ) VALUE(&JOBD)
 
/*/COPY UTCPYSRC,OBJEXIST                                         */
 
/* If the job description does not exist */
 
                IF         COND(&OBJEXISTS *EQ 'N') THEN(DO)
 
/*/COPY UTCPYSRC,OBJEXMSGN                                        */
 
                ENDDO
 
/* Check for errors */
 
/*/COPY UTCPYSRC,VC_END                                            */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTC0043_VC ended abnormally.  See joblog +
                          for more details') TOPGMQ(*PRV) +
                          MSGTYPE(*ESCAPE)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
