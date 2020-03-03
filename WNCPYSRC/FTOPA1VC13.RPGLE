      *****************************************************************
      *                                                               *
      *  FTOPAY1VL - Midas FT Outgoing payments validation control 1  *
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      *
      *****************************************************************         ERZ248
      *                                                               *         ERZ248
      *  VUETR     - Validate Unique End-to-End Transaction Reference *         ERZ248
      *                                                               *         ERZ248
      *  Called By: Main Processing                                   *         ERZ248
      *                                                               *         ERZ248
      *  Calls:                                                       *         ERZ248
      *  RESETERRS  - Resets variables updated by each modules        *         ERZ248
      *  FTVPYCD    - Payment Date Offset Code Validation Module      *         ERZ248
      *  UPDATERRS  - Updates error information                       *         ERZ248
      *                                                               *         ERZ248
      *****************************************************************         ERZ248
                                                                                ERZ248
     C     VUETR         BEGSR                                                  ERZ248
                                                                                ERZ248
      ** Reset variables updated by other modules                               ERZ248
                                                                                ERZ248
     C                   EXSR      RESETERRS                                    ERZ248
                                                                                ERZ248
      ** Validate Unique End-to-End Transaction Identifier                      ERZ248
                                                                                ERZ248
     C                   CALLB     'FTVUETR'                                    ERZ248
     C                   PARM                    RETCODEOUT                     ERZ248
     C                   PARM                    FLDNAMXAR                      ERZ248
     C                   PARM                    MSGIDXAR                       ERZ248
     C                   PARM                    MSGDTAXAR                      ERZ248
     C                   PARM                    ExtData                        ERZ248
     C                   PARM                    OKUETR            1            ERZ248
                                                                                ERZ248
      ** Update error info with that returned from the validation module        ERZ248
                                                                                ERZ248
     C                   EXSR      UPDATERRS                                    ERZ248
                                                                                ERZ248
     C                   ENDSR                                                  ERZ248
      *
