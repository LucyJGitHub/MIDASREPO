/*********************************************************************/
/*S*D****CLPBASE******************************************************/                 /*MD026169*/
/*STD    CLPBASEBND                                                  */                 /*MD026169*/
/*EXI    DFTACTGRP(*NO) ACTGRP(SCC000204)                            */                 /*MD026169*/
/*EXI    TEXT('Midas SC Submit SCC0204 background jobs')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC000204 - Midas Plus Sign On Submit background job        */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD034158           Date 04Jun15              */
/*                      MD026169           Date 04Apr14              */
/*                      MD025679A          Date 21Mar14              */
/*                      MD025679           Date 13Mar14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      AR687098           Date 04Sep12              */
/*                      BUG13040           Date 12Jan07              */
/*                      240093 *CREATE     Date 07Nov06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD034158 - Job SCC007001 missing due to lock on SCBKJOBMON. */
/*                  Deallocate SCBKJOBMON when MPHAS <> 'C'.         */
/*       MD026169 - GO_ONL_OLP background job is processing          */
/*                  full receiver chain                              */
/*       MD025679A - API - OLPOSOA Locking Issue Performance Update  */
/*       MD025679 - API - OLPOSOA Locking Issue.                     */
/*                - Reverse AR687098 and Change the SBMJOB to submit */
/*                  SCC007001 instead of SCC0204.                    */
/*       AR687098 - Switching off unnecessary job logging of SCC0204.*/
/*                  Correctly retrieve MPHAS. Applied fix 254376.    */
/*                  (Child: AR687099)                                */
/*       BUG13040 - Background job being submitted with wrong library*/
/*                  List.                                            */
/*       240093 - Start API background jobs                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2) */                     /*AR687098 MD025679*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2006')
 
/* Allocate SCBKJOBMON */                                                               /*MD025679*/
             ALCOBJ     OBJ((SCBKJOBMON *DTAQ *EXCLRD)) WAIT(0)                         /*MD025679*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                         /*MD025679*/
             GOTO       CMDLBL(END)                                                     /*MD025679*/
             ENDDO                                                                      /*MD025679*/
                                                                                        /*MD025679*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS) */                                 /*AR687098*/
/**********  CHGVAR     VAR(&PREFIX) VALUE(%SUBSTRING(&LIB 1 2)) */            /*AR687098 MD025679*/
/**********  RTVDTAARA  DTAARA((&PREFIX *CAT 'DMLIB')/MPHAS) RTNVAR(&MPHAS) */ /*AR687098 MD025679*/
 
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO) */                               /*MD025679A*/
/**********  IF         COND(&MPHAS *NE 'C') THEN(DO) */                      /*MD025679A MD026169*/
             IF         COND((&MPHAS *NE 'C') *AND (&MPHAS *NE 'N')) +
                          THEN(DO)                                                      /*MD026169*/
/*           SBMJOB     JOB(SCC0204) JOBD(&LIB/MBATCH) +           */  /*BUG13040*/
/*                        JOBQ(&LIB/INTERFACE) PRTDEV(*CURRENT) +  */  /*BUG13040*/
/*                        OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +  */  /*BUG13040*/
/*                        RQSDTA('CALL SCC0204')                   */  /*BUG13040*/
/**********  SBMJOB     JOB(SCC0204) JOBD(&LIB/MBATCH) + */                             /*MD025679*/
/**********               JOBQ(&LIB/INTERFACE) PRTDEV(*CURRENT) + */                    /*MD025679*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) + */                    /*MD025679*/
/**********               RQSDTA('CALL SCC0204') INLLIBL(*JOBD) */             /*BUG13040 AR687098*/
/**********  SBMJOB     JOB(SCC0204) JOBD(&LIB/MBATCHIC) + */                           /*MD025679*/
/**********               JOBQ(&LIB/INTERFACE) PRTDEV(*CURRENT) + */                    /*MD025679*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) + */                    /*MD025679*/
/**********               RQSDTA('CALL SCC0204') INLLIBL(*JOBD) */             /*AR687098 MD025679*/
 
             DLCOBJ     OBJ((SCBKJOBMON *DTAQ   *EXCLRD))
             SBMJOB     JOB(SCC007001) JOBD(&LIB/MBATCH) +
                          JOBQ(&LIB/INTERFACE) PRTDEV(*CURRENT) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL SCC007001') INLLIBL(*JOBD)                       /*MD025679*/
             ENDDO                                                                      /*MD034158*/
             ELSE       CMD(DO)                                                         /*MD034158*/
                DLCOBJ     OBJ((SCBKJOBMON *DTAQ *EXCLRD))                              /*MD034158*/
             ENDDO
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)                                               /*MD026169*/
             MONMSG     MSGID(CPF0000)                                                  /*MD026169*/
                                                                                        /*MD026169*/
             ENDPGM
