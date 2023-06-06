      *****************************************************************
      *  Start of /COPY HUT122_022                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDRTV - CUSTOMER DETAILS RETRIEVE                        *
      *              (WITH ACTION CODE VERSUS CUSTOMER NO VALIDATION  *
      *                                                               *
      *  Last Amend No. HUT122 *CREATE     Date 10May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT122 - Deletion of PMPORTPD SDEXSTPD and STDSED Details    *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT122
     C     HUT122        IFEQ      'Y'                                                        HUT122
      *                                                                                       HUT122
     C     WDS1008       IFEQ      'F'                                                        HUT122
     C     WDS1009       OREQ      'F'                                                        HUT122
     C     WDS1010       OREQ      'F'                                                        HUT122
     C     WDS1011       OREQ      'F'                                                        HUT122
     C     WDS1012       OREQ      'F'                                                        HUT122
     C     WDS1013       OREQ      'F'                                                        HUT122
     C     WDS1014       OREQ      'F'                                                        HUT122
     C     WDS1015       OREQ      'F'                                                        HUT122
     C     WDS1016       OREQ      'F'                                                        HUT122
     C     WDS1017       OREQ      'F'                                                        HUT122
     C     WDS1018       OREQ      'F'                                                        HUT122
     C     WDS1019       OREQ      'F'                                                        HUT122
     C     WDS1020       OREQ      'F'                                                        HUT122
     C                   MOVEL     'N'           WUERCD                                       HUT122
     C                   ENDIF                                                                HUT122
      *                                                                                       HUT122
     C                   ENDIF                                                                HUT122
      *                                                                                       HUT122
      *****************************************************************
      * End of /COPY HUT122_022                                       *
      *****************************************************************
