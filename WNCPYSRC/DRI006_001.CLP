/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member GLC39                                  */
/*                                                                   */
/*       DRI006_001 - MIDAS GL Declare DRI006 Variables              */
/*                                                                   */
/*       Last Ament No. DRI006  *CREATE    DATE 01Jun21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       DRI006 - ACCNTAB COB save at monthend                       */
/*                                                                   */
/*********************************************************************/
                                                                                      /*DRI006*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7) VALUE('  DMLIB')               /*DRI006*/
             DCL        VAR(&DRI006) TYPE(*CHAR) LEN(1) VALUE('N')                    /*DRI006*/
             DCL        VAR(&SVALLIB) TYPE(*CHAR) LEN(10)                             /*DRI006*/
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1)                                  /*DRI006*/
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)                                  /*DRI006*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)                                /*DRI006*/
             DCL        VAR(&POPV01) TYPE(*CHAR) LEN(20) +
                          VALUE('AccntabSavedLib')                                    /*DRI006*/
                                                                                      /*DRI006*/
/**********************************************************************/
/* End of /COPY DRI006_001                                           **/
/**********************************************************************/
