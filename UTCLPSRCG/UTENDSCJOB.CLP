/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midasplus - End HATS jobs in DSC status')             */
/*********************************************************************/
/*                                                                   */
/*       Midasplus                                                   */
/*                                                                   */
/*       UTENDSCJOB - Midasplus HATS jobs exit program               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       The purpose of this program is to ENDJOB the Midasplus      */
/*       jobs started through HATS.                                  */
/*       After the change done in the main.hco file to explicitly    */
/*       name the HATS jobs, it appeared that those jobs stayed in   */
/*       'disconnected' status after logout.                         */
/*       This program is added as Exit Program for Exit Point        */
/*       QIBM_QTG_DEVTERM.                                           */
/*       Note the following assumption:                              */
/*       => with the change done in the main.hco file, all HATS jobs */
/*       are started with name xx_SESSI## ('xx' being the global     */
/*       name and '##" being a wilcard).                             */
/*                                                                   */
/*       Last Amend No. MD020194A          Date 15May17              */
/*       Prev Amend No. MD020194           Date 15May17              */
/*                                                                   */
/* Midas Plus 1.4 ---------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD020194A - Set ENDJOB SPLFILE to No.                       */
/*                 - Applied for MD044282.                           */
/*       MD020194 - Midasplus HATS jobs exit program                 */
/*                 - Applied for MD044282.                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DEVNAME)

             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEVNAME) TYPE(*CHAR) LEN(10)
             DCLF       FILE(QTEMP/QPDSPJOB)

             MONMSG     MSGID(CPF0000 CPD0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))

/* Do further processng only if Device Name contains '_SESSI' */

             CHGVAR     VAR(&JOBNAME) VALUE(%SST(&DEVNAME 3 6))

             IF         COND(&JOBNAME = '_SESSI') THEN(DO)

             CRTPF      FILE(QTEMP/QPDSPJOB) RCDLEN(132)
             MONMSG     MSGID(CPF7302 CPF5813)

AGAIN:
             DLYJOB     DLY(1)

             DSPJOB     JOB(&DEVNAME) OUTPUT(*PRINT) OPTION(*STSA) +
                          DUPJOBOPT(*MSG)
             MONMSG     MSGID(CPF1069)

             CPYSPLF    FILE(QPDSPJOB) TOFILE(QTEMP/QPDSPJOB) +
                          SPLNBR(*LAST) MBROPT(*REPLACE)

             RCVF
 /* Line 2 contains job usereand number */
             RCVF
             CHGVAR     VAR(&JOBU) VALUE(%SST(&QPDSPJOB 44 10))
             CHGVAR     VAR(&JOBN) VALUE(%SST(&QPDSPJOB 77 6))
             RCVF
 /* Line 4 contains job status */
             RCVF
             CHGVAR     VAR(&STATUS) VALUE(%SST(&QPDSPJOB 53 10))

 /* If status is 'DSC', then cancel job */

             ENDJOB     JOB(&JOBN/&JOBU/&DEVNAME) OPTION(*IMMED) +
                          SPLFILE(*NO) LOGLMT(0)

             ENDDO

END:
             ENDPGM
